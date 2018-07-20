class Micropost < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  default_scope ->{order(created_at: :desc)}

  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 1000}
  validates :title, presence: true, length: {maximum: 140}
  validate :picture_size

  private
  def picture_size
    return unless picture.size > Settings.microposts.image_max_size_mb.megabytes
    errors.add(:picture,
      "should be less than #{Settings.microposts.image_max_size_mb}MB")
  end
end
