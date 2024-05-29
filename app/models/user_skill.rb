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
class UserSkill < ApplicationRecord
  CREATE_PARAMS = %w[skill_id].freeze

  belongs_to :user
  belongs_to :skill

  with_options presence: true do
    validates :user_id
    validates :user
    validates :skill_id
    validates :skill
  end

  validates :user_id, uniqueness: { scope: :skill_id, case_sensitive: false }
end
