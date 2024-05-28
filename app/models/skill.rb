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
class Skill < ApplicationRecord
  CREATE_PARAMS = %w[name].freeze

  belongs_to :created_user, class_name: 'User', foreign_key: 'created_by',
                            inverse_of: :created_skills, optional: true

  has_many :user_skills, dependent: :destroy
  has_many :users, through: :user_skills

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
