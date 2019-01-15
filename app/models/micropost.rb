class Micropost < ApplicationRecord
  belongs_to :user

  mount_uploader :picture, PictureUploader
  scope :desc, -> {order(created_at: :desc)}

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
