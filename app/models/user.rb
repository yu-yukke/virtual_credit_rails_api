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
#  image                :string
#  last_sign_in_at      :datetime
#  last_sign_in_ip      :string
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
  REGISTRATION_PARAMS = %w[email password password_confirmation confirm_success_url].freeze

  with_options presence: true do
    validates :email
    validates :encrypted_password
    validates :provider
    validates :sign_in_count
  end

  # activated userは必須
  with_options if: -> { activated? } do
    validates :name, :image, :slug, :description, presence: true
  end

  validates :email, uniqueness: true, format: { with: EMAIL_REGEXP }
  validates :published, inclusion: [true, false]
  validates :provider, inclusion: { in: PROVIDERS }
  validates :slug, uniqueness: true, allow_nil: true
  validates :sign_in_count, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }

  def confirmed?
    confirmed_at.present?
  end

  def activate!
    # TODO: activateAPI実装時に条件を改めて考えること
    return true if activated?

    unless confirmed?
      errors.add(:base, 'まだ認証が完了していないユーザーです。')

      raise ActiveRecord::RecordInvalid, self
    end

    self.activated_at = Time.zone.now
    save!
  end

  def activated?
    activated_at.present?
  end

  def publish!
    # TODO: publishAPI実装時に条件を改めて考えること
    return true if published?

    unless activated?
      errors.add(:base, 'まだアカウントが有効化されていないユーザーです。')

      raise ActiveRecord::RecordInvalid, self
    end

    self.published = true
    save!
  end

  def unpublish!
    # TODO: unpublishAPI実装時に条件を改めて考えること
    return true unless published?

    self.published = false
    save!
  end
end
