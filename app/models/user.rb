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
class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable,
         :trackable, :confirmable, :validatable
  include DeviseTokenAuth::Concerns::User
  include Rails.application.routes.url_helpers

  EMAIL_REGEXP = /\A[\w\-._]+@[\w\-._]+\.[A-Za-z]+\z/
  SLUG_REGEXP = /\A[a-zA-Z0-9][a-zA-Z0-9_-]*\z/
  PROVIDERS = ['email'].freeze
  REGISTRATION_PARAMS = %w[email password password_confirmation confirm_success_url].freeze

  has_one_attached :thumbnail_image

  has_one :social, dependent: :destroy

  has_many :user_skills, dependent: :destroy
  has_many :skills, through: :user_skills

  has_many :my_works, class_name: 'Work', dependent: :nullify,
                      inverse_of: :author

  has_many :created_skills, class_name: 'Skill', foreign_key: 'created_by',
                            dependent: :nullify, inverse_of: :created_user

  has_many :created_categories, class_name: 'Category', foreign_key: 'created_by',
                                dependent: :nullify, inverse_of: :created_user

  with_options presence: true do
    validates :email
    validates :encrypted_password
    validates :provider
    validates :sign_in_count
  end

  # activated userは必須
  with_options if: -> { activated? } do
    validates :name, :slug, :description, presence: true
    validates :thumbnail_image,
              attached: true,
              content_type: %w[image/png image/jpeg],
              size: { less_than: 5.megabytes }
  end

  validates :email, uniqueness: true, format: { with: EMAIL_REGEXP }
  validates :is_published, inclusion: [true, false]
  validates :provider, inclusion: { in: PROVIDERS }
  validates :slug, uniqueness: true,
                   format: { with: SLUG_REGEXP },
                   length: { in: 3..32 },
                   allow_nil: true
  validates :sign_in_count, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }

  after_create :create_associated_social!

  def thumbnail_image_url
    # 紐づいている画像のURLを取得する
    thumbnail_image.attached? ? url_for(thumbnail_image) : nil
  end

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
    return true if is_published?

    unless activated?
      errors.add(:base, 'まだアカウントが有効化されていないユーザーです。')

      raise ActiveRecord::RecordInvalid, self
    end

    self.is_published = true
    save!
  end

  def unpublish!
    # TODO: unpublishAPI実装時に条件を改めて考えること
    return true unless is_published?

    self.is_published = false
    save!
  end

  private

  def create_associated_social!
    create_social!
  end
end
