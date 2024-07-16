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
require 'rails_helper'

RSpec.describe User do
  subject { create(:user) }

  #   ....###.....######...######...#######...######..####....###....########.####..#######..##....##..######.
  #   ...##.##...##....##.##....##.##.....##.##....##..##....##.##......##.....##..##.....##.###...##.##....##
  #   ..##...##..##.......##.......##.....##.##........##...##...##.....##.....##..##.....##.####..##.##......
  #   .##.....##..######...######..##.....##.##........##..##.....##....##.....##..##.....##.##.##.##..######.
  #   .#########.......##.......##.##.....##.##........##..#########....##.....##..##.....##.##..####.......##
  #   .##.....##.##....##.##....##.##.....##.##....##..##..##.....##....##.....##..##.....##.##...###.##....##
  #   .##.....##..######...######...#######...######..####.##.....##....##....####..#######..##....##..######.

  it { is_expected.to have_one(:social) }

  it { is_expected.to have_many(:user_skills) }
  it { is_expected.to have_many(:skills).through(:user_skills) }

  it { is_expected.to have_many(:my_works) }

  it { is_expected.to have_many(:likes) }
  it { is_expected.to have_many(:liked_works).through(:likes) }

  it { is_expected.to have_many(:user_copyrights) }
  it { is_expected.to have_many(:copyrights).through(:user_copyrights) }

  it { is_expected.to have_many(:created_assets) }
  it { is_expected.to have_many(:created_categories) }
  it { is_expected.to have_many(:created_copyrights) }
  it { is_expected.to have_many(:created_skills) }
  it { is_expected.to have_many(:created_tags) }
  it { is_expected.to have_many(:created_user_copyrights) }
  it { is_expected.to have_many(:created_work_assets) }
  it { is_expected.to have_many(:created_work_categories) }
  it { is_expected.to have_many(:created_work_tags) }

  #   .##.....##....###....##.......####.########.....###....########.####..#######..##....##..######.
  #   .##.....##...##.##...##........##..##.....##...##.##......##.....##..##.....##.###...##.##....##
  #   .##.....##..##...##..##........##..##.....##..##...##.....##.....##..##.....##.####..##.##......
  #   .##.....##.##.....##.##........##..##.....##.##.....##....##.....##..##.....##.##.##.##..######.
  #   ..##...##..#########.##........##..##.....##.#########....##.....##..##.....##.##..####.......##
  #   ...##.##...##.....##.##........##..##.....##.##.....##....##.....##..##.....##.##...###.##....##
  #   ....###....##.....##.########.####.########..##.....##....##....####..#######..##....##..######.

  context 'when that is new user' do
    subject { create(:user, :new_user) }

    it { is_expected.not_to validate_presence_of :name }
    it { is_expected.not_to validate_presence_of :slug }
    it { is_expected.not_to validate_presence_of :description }

    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :provider }
    it { is_expected.to validate_presence_of :encrypted_password }
    it { is_expected.to validate_presence_of :sign_in_count }

    it { is_expected.not_to validate_attached_of(:thumbnail_image) }
  end

  context 'when that is new user confirmed' do
    subject { create(:user, :new_user, :confirmed) }

    it { is_expected.not_to validate_presence_of :name }
    it { is_expected.not_to validate_presence_of :slug }
    it { is_expected.not_to validate_presence_of :description }

    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :provider }
    it { is_expected.to validate_presence_of :encrypted_password }
    it { is_expected.to validate_presence_of :sign_in_count }

    it { is_expected.not_to validate_attached_of(:thumbnail_image) }
  end

  context 'when that is confirmed (not activated)' do
    subject { create(:user, :confirmed) }

    it { is_expected.not_to validate_presence_of :name }
    it { is_expected.not_to validate_presence_of :slug }
    it { is_expected.not_to validate_presence_of :description }

    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :provider }
    it { is_expected.to validate_presence_of :encrypted_password }
    it { is_expected.to validate_presence_of :sign_in_count }

    it { is_expected.not_to validate_attached_of(:thumbnail_image) }
  end

  context 'when that is activated (not published)' do
    subject { create(:user, :activated) }

    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :slug }
    it { is_expected.to validate_presence_of :description }

    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :provider }
    it { is_expected.to validate_presence_of :encrypted_password }
    it { is_expected.to validate_presence_of :sign_in_count }

    it { is_expected.to validate_attached_of(:thumbnail_image) }
    it { is_expected.to validate_content_type_of(:thumbnail_image).allowing('image/png', 'image/jpeg') }
    it { is_expected.to validate_size_of(:thumbnail_image).less_than(5.megabytes) }

    it { is_expected.to validate_uniqueness_of(:slug) }
    it { is_expected.to validate_length_of(:slug).is_at_least(3) }
    it { is_expected.to validate_length_of(:slug).is_at_most(32) }

    it { is_expected.to validate_numericality_of(:sign_in_count).is_greater_than_or_equal_to(0) }

    it { is_expected.to validate_inclusion_of(:provider).in_array(User::PROVIDERS) }
  end

  context 'when that is published' do
    subject { create(:user, :published) }

    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :slug }
    it { is_expected.to validate_presence_of :description }

    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :provider }
    it { is_expected.to validate_presence_of :encrypted_password }
    it { is_expected.to validate_presence_of :sign_in_count }

    it { is_expected.to validate_attached_of(:thumbnail_image) }
    it { is_expected.to validate_content_type_of(:thumbnail_image).allowing('image/png', 'image/jpeg') }
    it { is_expected.to validate_size_of(:thumbnail_image).less_than(5.megabytes) }

    it { is_expected.to validate_uniqueness_of(:slug) }
    it { is_expected.to validate_length_of(:slug).is_at_least(3) }
    it { is_expected.to validate_length_of(:slug).is_at_most(32) }

    it { is_expected.to validate_numericality_of(:sign_in_count).is_greater_than_or_equal_to(0) }

    it { is_expected.to validate_inclusion_of(:provider).in_array(User::PROVIDERS) }
  end

  #   .##.....##.########.########.##.....##..#######..########...######.
  #   .###...###.##..........##....##.....##.##.....##.##.....##.##....##
  #   .####.####.##..........##....##.....##.##.....##.##.....##.##......
  #   .##.###.##.######......##....#########.##.....##.##.....##..######.
  #   .##.....##.##..........##....##.....##.##.....##.##.....##.......##
  #   .##.....##.##..........##....##.....##.##.....##.##.....##.##....##
  #   .##.....##.########....##....##.....##..#######..########...######.

  #   .########.##.....##.##.....##.##.....##.########..##....##....###....####.##...............####.##.....##....###.....######...########.........##.....##.########..##......
  #   ....##....##.....##.##.....##.###...###.##.....##.###...##...##.##....##..##................##..###...###...##.##...##....##..##...............##.....##.##.....##.##......
  #   ....##....##.....##.##.....##.####.####.##.....##.####..##..##...##...##..##................##..####.####..##...##..##........##...............##.....##.##.....##.##......
  #   ....##....#########.##.....##.##.###.##.########..##.##.##.##.....##..##..##................##..##.###.##.##.....##.##...####.######...........##.....##.########..##......
  #   ....##....##.....##.##.....##.##.....##.##.....##.##..####.#########..##..##................##..##.....##.#########.##....##..##...............##.....##.##...##...##......
  #   ....##....##.....##.##.....##.##.....##.##.....##.##...###.##.....##..##..##................##..##.....##.##.....##.##....##..##...............##.....##.##....##..##......
  #   ....##....##.....##..#######..##.....##.########..##....##.##.....##.####.########.#######.####.##.....##.##.....##..######...########.#######..#######..##.....##.########

  describe '.thumbnail_image_url' do
    context 'when user has thumbnail_image' do
      let_it_be(:user) { create(:user, :activated) }

      it 'returns thumbnail_image_url' do
        expect(user.thumbnail_image_url).to be_a(String)
      end
    end

    context 'when user does not have thumbnail_image' do
      let_it_be(:user) { create(:user, :confirmed) }

      it 'returns nil' do
        expect(user.thumbnail_image_url).to be_nil
      end
    end
  end

  #   ......######...#######..##....##.########.####.########..##.....##.########.########...#######.
  #   .....##....##.##.....##.###...##.##........##..##.....##.###...###.##.......##.....##.##.....##
  #   .....##.......##.....##.####..##.##........##..##.....##.####.####.##.......##.....##.......##.
  #   .....##.......##.....##.##.##.##.######....##..########..##.###.##.######...##.....##.....###..
  #   .....##.......##.....##.##..####.##........##..##...##...##.....##.##.......##.....##....##....
  #   .###.##....##.##.....##.##...###.##........##..##....##..##.....##.##.......##.....##..........
  #   .###..######...#######..##....##.##.......####.##.....##.##.....##.########.########.....##....

  describe '.confirmed?' do
    context 'when user is not confirmed yet' do
      let_it_be(:user) { create(:user, :new_user) }

      it 'returns false' do
        expect(user.confirmed?).to be(false)
      end
    end

    context 'when user is confirmed' do
      let_it_be(:user) { create(:user, :new_user, :confirmed) }

      it 'returns true' do
        expect(user.confirmed?).to be(true)
      end
    end
  end

  #   ........###.....######..########.####.##.....##....###....########.########.####
  #   .......##.##...##....##....##.....##..##.....##...##.##......##....##.......####
  #   ......##...##..##..........##.....##..##.....##..##...##.....##....##.......####
  #   .....##.....##.##..........##.....##..##.....##.##.....##....##....######....##.
  #   .....#########.##..........##.....##...##...##..#########....##....##...........
  #   .###.##.....##.##....##....##.....##....##.##...##.....##....##....##.......####
  #   .###.##.....##..######.....##....####....###....##.....##....##....########.####

  describe '.activate!' do
    context 'when user has all information' do
      let_it_be(:user) { create(:user, :confirmed, :has_image) }

      it 'returns true' do
        expect(user.activate!).to be(true)
      end

      it 'update user to activated' do
        expect { user.activate! }.to change { user.reload.activated? }.to(true)
      end
    end

    context 'when user is already activated' do
      let_it_be(:user) { create(:user, :activated) }

      it 'returns true' do
        expect(user.activate!).to be(true)
      end

      it 'does not update user to not activated' do
        expect do
          user.activate!
        rescue StandardError
          nil
        end.not_to change { user.reload.activated? }.from(true)
      end
    end

    context 'when user is not confirmed yet' do
      let_it_be(:user) { create(:user, :new_user) }

      it 'raise ActiveRecord::RecordInvalid' do
        expect { user.activate! }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'does not update user to activated' do
        expect do
          user.activate!
        rescue StandardError
          nil
        end.not_to change { user.reload.activated? }.from(false)
      end
    end

    context 'when name is nil' do
      let_it_be(:user) { create(:user, :confirmed, name: nil) }

      it 'raise ActiveRecord::RecordInvalid' do
        expect { user.activate! }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'does not update user to activated' do
        expect do
          user.activate!
        rescue StandardError
          nil
        end.not_to change { user.reload.activated? }.from(false)
      end
    end

    context 'when image is nil' do
      let_it_be(:user) { create(:user, :confirmed) }

      it 'raise ActiveRecord::RecordInvalid' do
        expect { user.activate! }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'does not update user to activated' do
        expect do
          user.activate!
        rescue StandardError
          nil
        end.not_to change { user.reload.activated? }.from(false)
      end
    end

    context 'when slug is nil' do
      let_it_be(:user) { create(:user, :confirmed, slug: nil) }

      it 'raise ActiveRecord::RecordInvalid' do
        expect { user.activate! }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'does not update user to activated' do
        expect do
          user.activate!
        rescue StandardError
          nil
        end.not_to change { user.reload.activated? }.from(false)
      end
    end

    context 'when description is nil' do
      let_it_be(:user) { create(:user, :confirmed, description: nil) }

      it 'raise ActiveRecord::RecordInvalid' do
        expect { user.activate! }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'does not update user to activated' do
        expect do
          user.activate!
        rescue StandardError
          nil
        end.not_to change { user.reload.activated? }.from(false)
      end
    end
  end

  #   ........###.....######..########.####.##.....##....###....########.########.########...#######.
  #   .......##.##...##....##....##.....##..##.....##...##.##......##....##.......##.....##.##.....##
  #   ......##...##..##..........##.....##..##.....##..##...##.....##....##.......##.....##.......##.
  #   .....##.....##.##..........##.....##..##.....##.##.....##....##....######...##.....##.....###..
  #   .....#########.##..........##.....##...##...##..#########....##....##.......##.....##....##....
  #   .###.##.....##.##....##....##.....##....##.##...##.....##....##....##.......##.....##..........
  #   .###.##.....##..######.....##....####....###....##.....##....##....########.########.....##....

  describe '.activated?' do
    context 'when user is new user' do
      let_it_be(:user) { create(:user, :new_user) }

      it 'returns false' do
        expect(user.activated?).to be(false)
      end
    end

    context 'when user is confirmed new user' do
      let_it_be(:user) { create(:user, :new_user, :confirmed) }

      it 'returns false' do
        expect(user.activated?).to be(false)
      end
    end

    context 'when user is not activated yet' do
      let_it_be(:user) { create(:user, :confirmed) }

      it 'returns false' do
        expect(user.activated?).to be(false)
      end
    end

    context 'when user is activated' do
      let_it_be(:user) { create(:user, :activated) }

      it 'returns true' do
        expect(user.activated?).to be(true)
      end
    end
  end

  #   .....########..##.....##.########..##.......####..######..##.....##.####
  #   .....##.....##.##.....##.##.....##.##........##..##....##.##.....##.####
  #   .....##.....##.##.....##.##.....##.##........##..##.......##.....##.####
  #   .....########..##.....##.########..##........##...######..#########..##.
  #   .....##........##.....##.##.....##.##........##........##.##.....##.....
  #   .###.##........##.....##.##.....##.##........##..##....##.##.....##.####
  #   .###.##.........#######..########..########.####..######..##.....##.####

  describe '.publish!' do
    context 'when user is already published' do
      let_it_be(:user) { create(:user, :published) }

      it 'returns true' do
        expect(user.publish!).to be(true)
      end

      it 'does not update user to unpublished' do
        expect do
          user.publish!
        rescue StandardError
          nil
        end.not_to change { user.reload.is_published? }.from(true)
      end
    end

    context 'when user is not published' do
      let_it_be(:user) { create(:user, :activated) }

      it 'returns true' do
        expect(user.publish!).to be(true)
      end

      it 'update user to published' do
        expect { user.publish! }.to change { user.reload.is_published? }.to(true)
      end
    end

    context 'when user is not activated yet' do
      let_it_be(:user) { create(:user, :confirmed, :has_image) }

      it 'raise ActiveRecord::RecordInvalid' do
        expect { user.publish! }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'does not update user to published' do
        expect do
          user.publish!
        rescue StandardError
          nil
        end.not_to change { user.reload.is_published? }.from(false)
      end
    end

    context 'when name is nil' do
      let_it_be(:user) { create(:user, :confirmed, :has_image, name: nil) }

      it 'raise ActiveRecord::RecordInvalid' do
        expect { user.publish! }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'does not update user to published' do
        expect do
          user.publish!
        rescue StandardError
          nil
        end.not_to change { user.reload.is_published? }.from(false)
      end
    end

    context 'when thumbnail_image is nil' do
      let_it_be(:user) { create(:user, :confirmed) }

      it 'raise ActiveRecord::RecordInvalid' do
        expect { user.publish! }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'does not update user to published' do
        expect do
          user.publish!
        rescue StandardError
          nil
        end.not_to change { user.reload.is_published? }.from(false)
      end
    end

    context 'when slug is nil' do
      let_it_be(:user) { create(:user, :confirmed, :has_image, slug: nil) }

      it 'raise ActiveRecord::RecordInvalid' do
        expect { user.publish! }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'does not update user to published' do
        expect do
          user.publish!
        rescue StandardError
          nil
        end.not_to change { user.reload.is_published? }.from(false)
      end
    end

    context 'when description is nil' do
      let_it_be(:user) { create(:user, :confirmed, :has_image, description: nil) }

      it 'raise ActiveRecord::RecordInvalid' do
        expect { user.publish! }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'does not update user to published' do
        expect do
          user.publish!
        rescue StandardError
          nil
        end.not_to change { user.reload.is_published? }.from(false)
      end
    end
  end

  #   .....##.....##.##....##.########..##.....##.########..##.......####..######..##.....##.####
  #   .....##.....##.###...##.##.....##.##.....##.##.....##.##........##..##....##.##.....##.####
  #   .....##.....##.####..##.##.....##.##.....##.##.....##.##........##..##.......##.....##.####
  #   .....##.....##.##.##.##.########..##.....##.########..##........##...######..#########..##.
  #   .....##.....##.##..####.##........##.....##.##.....##.##........##........##.##.....##.....
  #   .###.##.....##.##...###.##........##.....##.##.....##.##........##..##....##.##.....##.####
  #   .###..#######..##....##.##.........#######..########..########.####..######..##.....##.####

  describe '.unpublish!' do
    context 'when user is not published' do
      let_it_be(:user) { create(:user, :activated) }

      it 'returns true' do
        expect(user.unpublish!).to be(true)
      end

      it 'does not update user to published' do
        expect do
          user.unpublish!
        rescue StandardError
          nil
        end.not_to change { user.reload.is_published? }.from(false)
      end
    end

    context 'when user is published' do
      let_it_be(:user) { create(:user, :published) }

      it 'returns true' do
        expect(user.unpublish!).to be(true)
      end

      it 'update user to unpublished' do
        expect { user.unpublish! }.to change { user.reload.is_published? }.to(false)
      end
    end
  end

  #   ..######..########..########....###....########.########............###.....######...######...#######...######..####....###....########.########.########...........######...#######...######..####....###....##.......####
  #   .##....##.##.....##.##.........##.##......##....##.................##.##...##....##.##....##.##.....##.##....##..##....##.##......##....##.......##.....##.........##....##.##.....##.##....##..##....##.##...##.......####
  #   .##.......##.....##.##........##...##.....##....##................##...##..##.......##.......##.....##.##........##...##...##.....##....##.......##.....##.........##.......##.....##.##........##...##...##..##.......####
  #   .##.......########..######...##.....##....##....######...........##.....##..######...######..##.....##.##........##..##.....##....##....######...##.....##..........######..##.....##.##........##..##.....##.##........##.
  #   .##.......##...##...##.......#########....##....##...............#########.......##.......##.##.....##.##........##..#########....##....##.......##.....##...............##.##.....##.##........##..#########.##...........
  #   .##....##.##....##..##.......##.....##....##....##...............##.....##.##....##.##....##.##.....##.##....##..##..##.....##....##....##.......##.....##.........##....##.##.....##.##....##..##..##.....##.##.......####
  #   ..######..##.....##.########.##.....##....##....########.#######.##.....##..######...######...#######...######..####.##.....##....##....########.########..#######..######...#######...######..####.##.....##.########.####

  describe '.create_associated_social!' do
    it 'creates a social record when a user is created' do
      user = create(:user)

      expect(user.social).to be_persisted
    end
  end
end
