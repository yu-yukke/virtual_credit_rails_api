# == Schema Information
#
# Table name: categories
#
#  id         :uuid             not null, primary key
#  created_by :uuid
#  name       :string           not null
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_categories_on_name  (name) UNIQUE
#
class Category < ApplicationRecord
  include CreatorTracking

  CREATE_PARAMS = %w[name].freeze

  belongs_to :created_user, class_name: 'User', foreign_key: 'created_by',
                            inverse_of: :created_categories, optional: true

  has_many :work_categories, dependent: :destroy
  has_many :works, through: :work_categories

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
