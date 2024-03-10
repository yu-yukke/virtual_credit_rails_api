# == Schema Information
#
# Table name: release_notes
#
#  id          :uuid             not null, primary key
#  description :text             not null
#  title       :string           not null
#  version     :string           not null
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_release_notes_on_version  (version) UNIQUE
#
class ReleaseNote < ApplicationRecord
  # kaminari
  default_scope -> { order(version: :desc) }
  paginates_per 24

  with_options presence: true do
    validates :version
    validates :title
    validates :description
  end

  validates :version,
            uniqueness: { case_sensitive: false },
            format: {
              with: /\A\d+\.\d+\.\d+\z/,
              message: 'はセマンティックバージョニングに従ってください'
            }

  def self.latest
    order(version: :desc).first
  end
end
