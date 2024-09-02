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
FactoryBot.define do
  factory :work_asset do
    work
    asset

    created_by { create(:user).id }
  end
end
