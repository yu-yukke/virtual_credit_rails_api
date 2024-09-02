# == Schema Information
#
# Table name: work_assets
#
#  id         :uuid             not null, primary key
#  created_by :uuid
#  created_at :datetime
#  updated_at :datetime
#  asset_id   :uuid             not null
#  work_id    :uuid             not null
#
# Indexes
#
#  index_work_assets_on_asset_id         (asset_id)
#  index_work_assets_on_work_asset_uniq  (work_id,asset_id) UNIQUE
#  index_work_assets_on_work_id          (work_id)
#
class WorkAsset < ApplicationRecord
  include CreatorTracking

  belongs_to :work
  belongs_to :asset

  belongs_to :created_user, class_name: 'User', foreign_key: 'created_by',
                            inverse_of: :created_work_assets, optional: true

  with_options presence: true do
    validates :work_id
    validates :work
    validates :asset_id
    validates :asset
  end

  validates :work_id, uniqueness: { scope: :asset_id, case_sensitive: false }
end
