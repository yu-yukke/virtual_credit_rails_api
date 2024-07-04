# == Schema Information
#
# Table name: likes
#
#  id         :uuid             not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  user_id    :uuid             not null
#  work_id    :uuid             not null
#
# Indexes
#
#  index_likes_on_user_id         (user_id)
#  index_likes_on_user_work_uniq  (user_id,work_id) UNIQUE
#  index_likes_on_work_id         (work_id)
#
FactoryBot.define do
  factory :like do
    user
    work
  end
end
