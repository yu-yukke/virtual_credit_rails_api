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
FactoryBot.define do
  factory :category do
    created_by { create(:user).id }
    name { Faker::Music.unique.genre }
  end
end
