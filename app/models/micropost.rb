class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image do |attachable|
    attachable.variant :display,
                       resize_to_limit: Settings.micropost.resize_to_limit
  end
  validates :user_id, presence: true
  validates :content, presence: true,
                      length: {maximum: Settings.digits.length_140}
  validates :image, content_type: {
                      in: Settings.micropost.image_type,
                      message: I18n.t("micropost.image.valid_format")
                    },
                    size: {
                      less_than: Settings.file.size_5.megabytes,
                      message: I18n.t("micropost.image.valid_size")
                    }
  scope :newest, ->{order(created_at: :desc)}
  scope :relate_post, ->(user_ids){where user_id: user_ids}
  delegate :name, to: :user, prefix: true
  def display_image
    image.variant(
      resize_to_limit: Settings.micropost.resize_to_limit
    )
  end
end
