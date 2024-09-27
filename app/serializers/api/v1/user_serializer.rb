# == Schema Information
#
# Table name: users
#
#  id                   :uuid             not null, primary key
#  activated_at         :datetime
#  confirmation_sent_at :datetime
#  confirmation_token   :string
#  confirmed_at         :datetime
#  current_sign_in_at   :datetime
#  current_sign_in_ip   :string
#  description          :text
#  email                :string           not null
#  encrypted_password   :string           default(""), not null
#  is_published         :boolean          default(FALSE), not null
#  last_sign_in_at      :datetime
#  last_sign_in_ip      :string
#  name                 :string
#  provider             :string           default("email"), not null
#  remember_created_at  :datetime
#  sign_in_count        :integer          default(0), not null
#  slug                 :string
#  tokens               :text
#  uid                  :string           default(""), not null
#  unconfirmed_email    :string
#  created_at           :datetime
#  updated_at           :datetime
#
# Indexes
#
#  index_users_on_confirmation_token  (confirmation_token) UNIQUE
#  index_users_on_email               (email) UNIQUE
#  index_users_on_name                (name)
#  index_users_on_slug                (slug) UNIQUE
#  index_users_on_uid_provider        (uid,provider) UNIQUE
#
class Api::V1::UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :slug, :cover_image_url, :thumbnail_image_url,
             :my_works, :copyrighted_works

  delegate :cover_image_url, to: :object
  delegate :thumbnail_image_url, to: :object

  has_one :social, serializer: Api::V1::SocialSerializer

  has_many :skills, serializer: Api::V1::SkillSerializer

  def my_works
    ActiveModelSerializers::SerializableResource.new(
      object.my_works.published,
      each_serializer: Api::V1::SimpleWorkSerializer
    ).serializable_hash
  end

  def copyrighted_works
    ActiveModelSerializers::SerializableResource.new(
      object.copyrighted_works,
      each_serializer: Api::V1::SimpleWorkSerializer
    ).serializable_hash
  end
end
