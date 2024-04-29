# == Schema Information
#
# Table name: users
#
#  id                   :uuid             not null, primary key
#  activated_at         :datetime
#  confirmation_sent_at :datetime
#  confirmation_token   :string
#  confirmed_at         :datetime
#  current_sign_in_at   :datetime
#  current_sign_in_ip   :string
#  description          :text
#  email                :string           not null
#  encrypted_password   :string           default(""), not null
#  last_sign_in_at      :datetime
#  last_sign_in_ip      :string
#  name                 :string
#  provider             :string           default("email"), not null
#  published            :boolean          default(FALSE), not null
#  remember_created_at  :datetime
#  sign_in_count        :integer          default(0), not null
#  slug                 :string
#  tokens               :text
#  uid                  :string           default(""), not null
#  unconfirmed_email    :string
#  created_at           :datetime
#  updated_at           :datetime
#
# Indexes
#
#  index_users_on_confirmation_token  (confirmation_token) UNIQUE
#  index_users_on_email               (email) UNIQUE
#  index_users_on_name                (name)
#  index_users_on_slug                (slug) UNIQUE
#  index_users_on_uid_provider        (uid,provider) UNIQUE
#
FactoryBot.define do
  factory :user do
    name { Faker::Internet.username }
    email { Faker::Internet.email }
    password = Faker::Internet.password(min_length: 8)
    password { password }
    password_confirmation { password }
    slug { Faker::Internet.unique.slug }
    description { Faker::Lorem.paragraph }

    trait :new_user do
      name { nil }
      email { Faker::Internet.email }
      password = Faker::Internet.password(min_length: 8)
      password { password }
      password_confirmation { password }
      slug { nil }
      description { nil }
      activated_at { nil }
    end

    trait :confirmed do
      after(:create, &:confirm)
    end

    trait :activated do
      after(:build) do |user|
        user.thumbnail_image.attach(
          io: File.open('spec/fixtures/takaomi.jpeg'),
          filename: 'takaomi.jpeg',
          content_type: 'image/jpeg'
        )
      end

      after(:create) do |user|
        user.confirm
        user.activate!
      end
    end

    trait :published do
      after(:build) do |user|
        user.thumbnail_image.attach(
          io: File.open('spec/fixtures/takaomi.jpeg'),
          filename: 'takaomi.jpeg',
          content_type: 'image/jpeg'
        )
      end

      after(:create) do |user|
        user.confirm
        user.activate!
        user.publish!
      end
    end

    trait :has_image do
      after(:build) do |user|
        user.thumbnail_image.attach(
          io: File.open('spec/fixtures/takaomi.jpeg'),
          filename: 'takaomi.jpeg',
          content_type: 'image/jpeg'
        )
      end
    end
  end
end
