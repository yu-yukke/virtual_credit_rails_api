# == Schema Information
#
# Table name: works
#
#  id           :uuid             not null, primary key
#  description  :text             not null
#  is_published :boolean          default(FALSE), not null
#  title        :string           not null
#  created_at   :datetime
#  updated_at   :datetime
#  user_id      :uuid
#
# Indexes
#
#  index_works_on_user_id  (user_id)
#
FactoryBot.define do
  factory :work do
    author factory: %i[user]

    title { Faker::Lorem.word }
    description { Faker::Lorem.paragraphs }

    after(:build) do |work|
      work.cover_image.attach(
        io: File.open('spec/fixtures/bg_sample_1.jpeg'),
        filename: 'bg_sample_1.jpeg',
        content_type: 'image/jpeg'
      )
    end

    trait :published do
      is_published { true }
    end

    trait :unpublished do
      is_published { false }
    end

    trait :has_images do
      after(:build) do |work|
        work.images.attach(
          io: File.open('spec/fixtures/bg_sample_1.jpeg'),
          filename: 'bg_sample_1.jpeg',
          content_type: 'image/jpeg'
        )
      end
    end

    trait :with_users do
      after(:create) do |work|
        rand(1..3).times do
          copyright = create(:copyright, work:)

          create(:user_copyright, user: create(:user), copyright:)
        end
      end
    end
  end
end
