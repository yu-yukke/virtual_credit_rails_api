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

  has_one_attached :cover_image
  has_many_attached :images

  belongs_to :author, class_name: 'User', foreign_key: 'user_id',
                      inverse_of: :my_works, optional: true

  with_options presence: true do
    validates :title
    validates :description
  end

  validates :is_published, inclusion: [true, false]
  validates :cover_image,
            attached: true,
            content_type: %w[image/png image/jpeg],
            size: { less_than: 8.megabytes }
  validates :images,
            content_type: %w[image/png image/jpeg],
            size: { less_than: 8.megabytes }

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
    url_for(cover_image)
  end
end
