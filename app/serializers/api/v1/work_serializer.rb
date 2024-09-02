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
class Api::V1::WorkSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :is_published, :cover_image_url,
             :images, :is_author

  delegate :cover_image_url, to: :object

  belongs_to :author, serializer: Api::V1::SimpleUserSerializer

  has_many :assets, serializer: Api::V1::AssetSerializer
  has_many :categories, serializer: Api::V1::CategorySerializer
  has_many :tags, serializer: Api::V1::TagSerializer
  has_many :copyrights, serializer: Api::V1::CopyrightSerializer

  def images
    object.images_urls
  end

  def is_author
    instance_options[:current_user].present? && object.author == instance_options[:current_user]
  end
end
