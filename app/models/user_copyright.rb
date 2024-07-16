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
class UserCopyright < ApplicationRecord
  belongs_to :user
  belongs_to :copyright

  belongs_to :created_user, class_name: 'User', foreign_key: 'created_by',
                            inverse_of: :created_user_copyrights, optional: true

  with_options presence: true do
    validates :user_id
    validates :user
    validates :copyright_id
    validates :copyright
  end

  validates :user_id, uniqueness: { scope: :copyright_id, case_sensitive: false }
end
