# == Schema Information
#
# Table name: copyrights
#
#  id         :uuid             not null, primary key
#  created_by :uuid
#  name       :string           not null
#  created_at :datetime
#  updated_at :datetime
#  work_id    :uuid             not null
#
# Indexes
#
#  index_copyrights_on_work_name_uniq  (work_id,name) UNIQUE
#
class Copyright < ApplicationRecord
  include CreatorTracking

  belongs_to :work

  belongs_to :created_user, class_name: 'User', foreign_key: 'created_by',
                            inverse_of: :created_copyrights, optional: true

  with_options presence: true do
    validates :name
    validates :work_id
    validates :work
  end

  validates :name, uniqueness: { scope: :work_id, case_sensitive: false }
end
