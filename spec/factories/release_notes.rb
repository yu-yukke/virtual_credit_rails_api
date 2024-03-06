# == Schema Information
#
# Table name: release_notes
#
#  id          :uuid             not null, primary key
#  description :text             not null
#  title       :string(191)      not null
#  version     :string(191)      not null
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_release_notes_on_version  (version) UNIQUE
#
FactoryBot.define do
  factory :release_note do
    version { Faker::App.unique.semantic_version }
    title { Faker::Lorem.sentence }
    description { Faker::Markdown.sandwich(sentences: 6, repeat: 3) }
  end
end
