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
        io: File.open('spec/fixtures/takaomibg.jpeg'),
        filename: 'takaomibg.jpeg',
        content_type: 'image/jpeg'
      )
    end

    trait :published do
      is_published { true }
    end
  end
end
