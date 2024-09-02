# == Schema Information
#
# Table name: user_copyrights
#
#  id           :uuid             not null, primary key
#  created_by   :uuid
#  created_at   :datetime
#  updated_at   :datetime
#  copyright_id :uuid             not null
#  user_id      :uuid             not null
#
# Indexes
#
#  index_user_copyrights_on_copyright_id         (copyright_id)
#  index_user_copyrights_on_user_copyright_uniq  (user_id,copyright_id) UNIQUE
#  index_user_copyrights_on_user_id              (user_id)
#
FactoryBot.define do
  factory :user_copyright do
    user
    copyright

    created_by { create(:user).id }
  end
end
