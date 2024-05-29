# == Schema Information
#
# Table name: user_skills
#
#  id         :uuid             not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  skill_id   :uuid             not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_user_skills_on_skill_id         (skill_id)
#  index_user_skills_on_user_id          (user_id)
#  index_user_skills_on_user_skill_uniq  (user_id,skill_id) UNIQUE
#
FactoryBot.define do
  factory :user_skill do
    user
    skill
  end
end
