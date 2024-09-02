# == Schema Information
#
# Table name: assets
#
#  id         :uuid             not null, primary key
#  created_by :uuid
#  name       :string           not null
#  url        :string
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_assets_on_name  (name) UNIQUE
#
class Api::V1::AssetSerializer < ActiveModel::Serializer
  attributes :id, :name, :url
end
