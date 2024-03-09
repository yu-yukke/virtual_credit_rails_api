# == Schema Information
#
# Table name: users
#
#  id                   :uuid             not null, primary key
#  confirmation_sent_at :datetime
#  confirmation_token   :string
#  confirmed_at         :datetime
#  current_sign_in_at   :datetime
#  description          :text
#  encrypted_password   :string           default(""), not null
#  image                :string
#  last_sign_in_at      :datetime
#  name                 :string
#  provider             :string           default("email"), not null
#  published            :boolean          default(FALSE), not null
#  remember_created_at  :datetime
#  sign_in_count        :integer          default(0), not null
#  slug                 :string
#  tokens               :text
#  unconfirmed_email    :string
#  created_at           :datetime
#  updated_at           :datetime
#
# Indexes
#
#  index_users_on_confirmation_token  (confirmation_token) UNIQUE
#  index_users_on_name                (name)
#  index_users_on_slug                (slug) UNIQUE
#
FactoryBot.define do
  factory :user do
    name { Faker::Internet.username }
  end
end
