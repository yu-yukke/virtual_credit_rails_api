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
FactoryBot.define do
  factory :asset do
    created_by { create(:user).id }
    name { Faker::Commerce.unique.material }
    url { Faker::Internet.url }
  end
end
