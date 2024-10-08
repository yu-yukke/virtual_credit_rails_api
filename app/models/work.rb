# == Schema Information
#
# Table name: works
#
#  id           :uuid             not null, primary key
#  description  :text             not null
#  is_published :boolean          default(FALSE), not null
#  title        :string           not null
#  created_at   :datetime
#  updated_at   :datetime
#  user_id      :uuid
#
# Indexes
#
#  index_works_on_user_id  (user_id)
#
class Work < ApplicationRecord
  include Rails.application.routes.url_helpers

  CREATE_PARAMS = %w[title description cover_image].freeze
  CREATE_WORK_ASSET_PARAMS = %w[id].freeze
  CREATE_WORK_CATEGORY_PARAMS = %w[id].freeze
  CREATE_WORK_TAG_PARAMS = %w[id].freeze
  CREATE_WORK_IMAGE_PARAMS = %w[content].freeze

  # kaminari
  default_scope -> { order(created_at: :desc) }
  paginates_per 24

  has_one_attached :cover_image
  has_many_attached :images

  belongs_to :author, class_name: 'User', foreign_key: 'user_id',
                      inverse_of: :my_works, optional: true

  has_many :copyrights, dependent: :destroy

  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  has_many :work_assets, dependent: :destroy
  has_many :assets, through: :work_assets

  has_many :work_categories, dependent: :destroy
  has_many :categories, through: :work_categories

  has_many :work_tags, dependent: :destroy
  has_many :tags, through: :work_tags

  with_options presence: true do
    validates :title
    validates :description
  end

  validates :is_published, inclusion: [true, false]
  validates :cover_image,
            attached: true,
            content_type: %w[image/png image/jpeg],
            size: { less_than: 16.megabytes }
  validates :images,
            content_type: %w[image/png image/jpeg],
            size: { less_than: 16.megabytes }

  scope :published, -> { where(is_published: true) }

  def publish!
    # TODO: publishAPI実装時に条件を改めて考えること
    return true if is_published?

    self.is_published = true
    save!
  end

  def unpublish!
    # TODO: unpublishAPI実装時に条件を改めて考えること
    return true unless is_published?

    self.is_published = false
    save!
  end

  def cover_image_url
    rails_storage_proxy_url(cover_image, only_path: true)
  end

  def images_urls
    images.map do |image|
      {
        url: rails_storage_proxy_url(image, only_path: true)
      }
    end
  end

  def user_count
    copyrights.joins(user_copyrights: :user)
      .where(users: { is_published: true })
      .select('user_copyrights.user_id')
      .distinct
      .count
  end
end
