# == Schema Information
#
# Table name: works
#
#  id           :uuid             not null, primary key
#  description  :text             not null
#  is_published :boolean          default(FALSE), not null
#  title        :string           not null
#  created_at   :datetime
#  updated_at   :datetime
#  user_id      :uuid
#
# Indexes
#
#  index_works_on_user_id  (user_id)
#
class Api::V1::SimpleWorkSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :is_published, :cover_image_url, :images

  delegate :cover_image_url, to: :object

  def images
    object.images_urls
  end
end
