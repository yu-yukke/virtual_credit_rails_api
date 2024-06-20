# == Schema Information
#
# Table name: work_categories
#
#  id          :uuid             not null, primary key
#  created_by  :uuid
#  created_at  :datetime
#  updated_at  :datetime
#  category_id :uuid             not null
#  work_id     :uuid             not null
#
# Indexes
#
#  index_work_categories_on_category_id         (category_id)
#  index_work_categories_on_work_category_uniq  (work_id,category_id) UNIQUE
#  index_work_categories_on_work_id             (work_id)
#
class WorkCategory < ApplicationRecord
  belongs_to :work
  belongs_to :category

  belongs_to :created_user, class_name: 'User', foreign_key: 'created_by',
                            inverse_of: :created_work_categories, optional: true

  with_options presence: true do
    validates :work_id
    validates :work
    validates :category_id
    validates :category
  end

  validates :work_id, uniqueness: { scope: :category_id, case_sensitive: false }
end
