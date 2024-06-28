# == Schema Information
#
# Table name: categories
#
#  id         :uuid             not null, primary key
#  created_by :uuid
#  name       :string           not null
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_categories_on_name  (name) UNIQUE
#
class Api::V1::CategorySerializer < ActiveModel::Serializer
  attributes :id, :name
end
