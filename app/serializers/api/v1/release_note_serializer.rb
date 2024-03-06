# == Schema Information
#
# Table name: release_notes
#
#  id          :uuid             not null, primary key
#  description :text             not null
#  title       :string(191)      not null
#  version     :string(191)      not null
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_release_notes_on_version  (version) UNIQUE
#
class Api::V1::ReleaseNoteSerializer < ActiveModel::Serializer
  attributes :id, :version, :title, :description, :created_at
end
