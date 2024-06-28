# == Schema Information
#
# Table name: work_tags
#
#  id         :uuid             not null, primary key
#  created_by :uuid
#  created_at :datetime
#  updated_at :datetime
#  tag_id     :uuid             not null
#  work_id    :uuid             not null
#
# Indexes
#
#  index_work_tags_on_tag_id         (tag_id)
#  index_work_tags_on_work_id        (work_id)
#  index_work_tags_on_work_tag_uniq  (work_id,tag_id) UNIQUE
#
FactoryBot.define do
  factory :work_tag do
    work
    tag

    created_by { create(:user).id }
  end
end
