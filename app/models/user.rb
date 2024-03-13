# == Schema Information
#
# Table name: users
#
#  id                   :uuid             not null, primary key
#  confirmation_sent_at :datetime
#  confirmation_token   :string
#  confirmed_at         :datetime
#  current_sign_in_at   :datetime
#  description          :text
#  email                :string           not null
#  encrypted_password   :string           default(""), not null
#  image                :string
#  last_sign_in_at      :datetime
#  name                 :string
#  provider             :string           default("email"), not null
#  published            :boolean          default(FALSE), not null
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
class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable,
         :trackable, :confirmable, :validatable
  include DeviseTokenAuth::Concerns::User

  EMAIL_REGEXP = /\A[\w\-._]+@[\w\-._]+\.[A-Za-z]+\z/
  PROVIDERS = ['email'].freeze
  REGISTRATION_PARAMS = %w[email password password_confirmation].freeze

  with_options presence: true do
    validates :email
    validates :encrypted_password
    validates :provider
    validates :sign_in_count
  end

  validates :email, uniqueness: true, format: { with: EMAIL_REGEXP }
  validates :published, inclusion: [true, false]
  validates :provider, inclusion: { in: PROVIDERS }
  validates :slug, uniqueness: true, allow_nil: true
  validates :sign_in_count, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }
end
