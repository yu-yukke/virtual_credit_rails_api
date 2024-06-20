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
FactoryBot.define do
  factory :work_category do
    work
    category

    created_by { create(:user).id }
  end
end
