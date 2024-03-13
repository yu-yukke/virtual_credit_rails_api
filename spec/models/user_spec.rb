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
require 'rails_helper'

RSpec.describe User do
  #
  # validations
  #

  context 'when that is activated' do
    subject { build(:user) }

    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :slug }
    it { is_expected.to validate_presence_of :image }
    it { is_expected.to validate_presence_of :description }

    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :provider }
    it { is_expected.to validate_presence_of :encrypted_password }
    it { is_expected.to validate_presence_of :sign_in_count }

    it { is_expected.to validate_uniqueness_of(:slug) }

    it { is_expected.to validate_numericality_of(:sign_in_count).is_greater_than_or_equal_to(0) }

    it { is_expected.to validate_inclusion_of(:provider).in_array(User::PROVIDERS) }
  end

  context 'when that is not activated' do
    subject { build(:user, :not_activated, name: nil, slug: nil, image: nil, description: nil) }

    it { is_expected.not_to validate_presence_of :name }
    it { is_expected.not_to validate_presence_of :slug }
    it { is_expected.not_to validate_presence_of :image }
    it { is_expected.not_to validate_presence_of :description }
  end

  #
  # methods
  #
  describe '.activated?' do
    context 'when user is not activated' do
      let_it_be(:user) { create(:user, :not_activated) }

      it 'returns false' do
        expect(user.activated?).to be(false)
      end
    end

    context 'when user is activated' do
      let_it_be(:user) { create(:user) }

      it 'returns true' do
        expect(user.activated?).to be(true)
      end
    end
  end
end
