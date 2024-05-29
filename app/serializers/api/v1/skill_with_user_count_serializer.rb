# == Schema Information
#
# Table name: skills
#
#  id         :uuid             not null, primary key
#  created_by :uuid
#  name       :string           not null
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_skills_on_name  (name) UNIQUE
#
class Api::V1::SkillWithUserCountSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_count

  delegate :user_count, to: :object
end
