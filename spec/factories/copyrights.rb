# == Schema Information
#
# Table name: copyrights
#
#  id         :uuid             not null, primary key
#  created_by :uuid
#  name       :string           not null
#  created_at :datetime
#  updated_at :datetime
#  work_id    :uuid             not null
#
# Indexes
#
#  index_copyrights_on_work_name_uniq  (work_id,name) UNIQUE
#
FactoryBot.define do
  factory :copyright do
    work

    name { Faker::Music.unique.band }
    created_by { create(:user).id }
  end
end
