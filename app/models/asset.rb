# == Schema Information
#
# Table name: assets
#
#  id         :uuid             not null, primary key
#  created_by :uuid
#  name       :string           not null
#  url        :string
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_assets_on_name  (name) UNIQUE
#
class Asset < ApplicationRecord
  include CreatorTracking

  CREATE_PARAMS = %w[name].freeze
  URL_REGEXP = %r{\Ahttps?://(?:www\.)?(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(?::\d+)?(?:/\S*)?\z}

  belongs_to :created_user, class_name: 'User', foreign_key: 'created_by',
                            inverse_of: :created_assets, optional: true

  validates :url, format: { with: URL_REGEXP }, allow_blank: true
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
