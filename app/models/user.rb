class User < ApplicationRecord
  attr_reader :remember_token, :activation_token, :reset_token

  has_many :microposts, dependent: :destroy
  has_secure_password
  has_many :active_relationships, class_name: Relationship.name,
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  validates :name, presence: true, length: {maximum: Settings.name.maximum}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: Settings.email.maximum},
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: {minimum: Settings.password.minimum}, allow_nil: true

  before_save :downcase_email
  before_create :create_activation_digest

  scope :activated, -> {where activated: true}
  scope :desc, -> {order(name: :desc)}

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    @remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def current_user? user
    self == user
  end

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def User.new_token
      SecureRandom.urlsafe_base64
    end
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def forget
    update remember_digest: nil
  end

  def password_reset_expired?
    reset_sent_at < Settings.time.hours.ago
  end

  def create_activation_digest
    @activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def create_reset_digest
    @reset_token = User.new_token
    update reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def feed
    listId = Relationship.following_ids(id).map(&:followed_id)
    Micropost.by_user_follow listId, id
  end

  def follow other_user
    following << other_user
  end

  def unfollow other_user
    following.delete(other_user)
  end

  def following? other_user
    following.include?(other_user)
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
