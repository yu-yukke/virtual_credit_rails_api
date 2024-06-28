# == Schema Information
#
# Table name: work_tags
#
#  id         :uuid             not null, primary key
#  created_by :uuid
#  created_at :datetime
#  updated_at :datetime
#  tag_id     :uuid             not null
#  work_id    :uuid             not null
#
# Indexes
#
#  index_work_tags_on_tag_id         (tag_id)
#  index_work_tags_on_work_id        (work_id)
#  index_work_tags_on_work_tag_uniq  (work_id,tag_id) UNIQUE
#
class WorkTag < ApplicationRecord
  include CreatorTracking

  belongs_to :work
  belongs_to :tag

  belongs_to :created_user, class_name: 'User', foreign_key: 'created_by',
                            inverse_of: :created_work_tags, optional: true

  with_options presence: true do
    validates :work_id
    validates :work
    validates :tag_id
    validates :tag
  end

  validates :work_id, uniqueness: { scope: :tag_id, case_sensitive: false }
end
