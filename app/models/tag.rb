# == Schema Information
#
# Table name: tags
#
#  id         :uuid             not null, primary key
#  created_by :uuid
#  name       :string           not null
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_tags_on_name  (name) UNIQUE
#
class Tag < ApplicationRecord
  include CreatorTracking

  CREATE_PARAMS = %w[name].freeze

  belongs_to :created_user, class_name: 'User', foreign_key: 'created_by',
                            inverse_of: :created_tags, optional: true

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
