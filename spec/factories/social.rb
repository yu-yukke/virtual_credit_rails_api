# == Schema Information
#
# Table name: socials
#
#  id          :uuid             not null, primary key
#  website_url :string
#  created_at  :datetime
#  updated_at  :datetime
#  user_id     :uuid             not null
#  x_id        :string
#
# Indexes
#
#  index_socials_on_user_id  (user_id)
#
FactoryBot.define do
  factory :social do
    user

    website_url { Faker::Internet.url }
    x_id { Faker::Internet.slug }
  end
end
