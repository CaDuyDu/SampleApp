class Micropost < ApplicationRecord
  belongs_to :user

  mount_uploader :picture, PictureUploader
  scope :desc, -> {order(created_at: :desc)}
  scope :by_user_follow, -> (following_ids, id){where("user_id IN (?) OR user_id = ?",
    following_ids,"#{id}")}

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost.maximum}
  validate :picture_size

  private

  def picture_size
    if picture.size > Settings.sizes.image.megabytes
      errors.add(:picture, t("should_be_less_than_5MB"))
    end
  end
end
