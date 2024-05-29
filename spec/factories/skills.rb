# == Schema Information
#
# Table name: skills
#
#  id         :uuid             not null, primary key
#  created_by :uuid
#  name       :string           not null
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_skills_on_name  (name) UNIQUE
#
FactoryBot.define do
  factory :skill do
    created_by { create(:user).id }
    name { Faker::Internet.slug }

    trait :with_users do
      after(:create) do |skill|
        skill.users << create_list(:user, rand(1..5), :confirmed)
      end
    end
  end
end
