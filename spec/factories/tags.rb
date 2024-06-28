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
FactoryBot.define do
  factory :tag do
    created_by { create(:user).id }
    name { Faker::Internet.unique.slug }
  end
end
