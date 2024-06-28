# == Schema Information
#
# Table name: tags
#
#  id         :uuid             not null, primary key
#  created_by :uuid
#  name       :string           not null
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_tags_on_name  (name) UNIQUE
#
class Api::V1::TagSerializer < ActiveModel::Serializer
  attributes :id, :name
end
