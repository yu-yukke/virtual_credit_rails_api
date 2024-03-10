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
#  index_users_on_email               (email)
#  index_users_on_name                (name)
#  index_users_on_slug                (slug) UNIQUE
#
class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable,
         :trackable, :confirmable
  include DeviseTokenAuth::Concerns::User

  PROVIDERS = ['email'].freeze

  with_options presence: true do
    validates :email
    validates :published
    validates :encrypted_password
    validates :provider
    validates :sign_in_count
  end

  validates :provider, inclusion: { in: PROVIDERS }
  validates :slug, uniqueness: true
  validates :sign_in_count, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }
end
