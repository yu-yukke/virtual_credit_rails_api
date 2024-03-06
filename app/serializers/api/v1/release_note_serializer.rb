class Api::V1::ReleaseNoteSerializer < ActiveModel::Serializer
  attributes :id, :version, :title, :description, :created_at
end
