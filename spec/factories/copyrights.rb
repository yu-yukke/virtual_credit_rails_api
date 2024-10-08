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

    sequence(:name) { |n| "Copyright #{n}" }
    created_by { create(:user).id }

    trait :with_work do
      after(:create) do |copyright|
        copyright.work = create(:work, :published, :has_images)
      end
    end
  end
end
