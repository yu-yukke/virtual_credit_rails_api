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
require 'rails_helper'

RSpec.describe Work do
  subject { create(:work) }

  #   ....###.....######...######...#######...######..####....###....########.####..#######..##....##..######.
  #   ...##.##...##....##.##....##.##.....##.##....##..##....##.##......##.....##..##.....##.###...##.##....##
  #   ..##...##..##.......##.......##.....##.##........##...##...##.....##.....##..##.....##.####..##.##......
  #   .##.....##..######...######..##.....##.##........##..##.....##....##.....##..##.....##.##.##.##..######.
  #   .#########.......##.......##.##.....##.##........##..#########....##.....##..##.....##.##..####.......##
  #   .##.....##.##....##.##....##.##.....##.##....##..##..##.....##....##.....##..##.....##.##...###.##....##
  #   .##.....##..######...######...#######...######..####.##.....##....##....####..#######..##....##..######.

  it { is_expected.to belong_to(:author).class_name('User').optional }

  it { is_expected.to have_many(:copyrights) }
  it { is_expected.to have_many(:likes) }
  it { is_expected.to have_many(:liked_users).through(:likes) }

  it { is_expected.to have_many(:work_assets) }
  it { is_expected.to have_many(:assets).through(:work_assets) }
  it { is_expected.to have_many(:work_categories) }
  it { is_expected.to have_many(:categories).through(:work_categories) }
  it { is_expected.to have_many(:work_tags) }
  it { is_expected.to have_many(:tags).through(:work_tags) }

  context 'when author is deleted' do
    subject(:destroy_author) { author.destroy }

    let_it_be(:author) { create(:user) }
    let_it_be(:work) { create(:work, author:) }

    it 'updates user_id to nil' do
      expect { destroy_author }.to change { work.reload.user_id }.from(author.id).to(nil)
    end

    it 'updates author to nil' do
      expect { destroy_author }.to change { work.reload.author }.from(author).to(nil)
    end
  end

  #   .##.....##....###....##.......####.########.....###....########.####..#######..##....##..######.
  #   .##.....##...##.##...##........##..##.....##...##.##......##.....##..##.....##.###...##.##....##
  #   .##.....##..##...##..##........##..##.....##..##...##.....##.....##..##.....##.####..##.##......
  #   .##.....##.##.....##.##........##..##.....##.##.....##....##.....##..##.....##.##.##.##..######.
  #   ..##...##..#########.##........##..##.....##.#########....##.....##..##.....##.##..####.......##
  #   ...##.##...##.....##.##........##..##.....##.##.....##....##.....##..##.....##.##...###.##....##
  #   ....###....##.....##.########.####.########..##.....##....##....####..#######..##....##..######.

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:description) }

  it { is_expected.to validate_attached_of(:cover_image) }
  it { is_expected.to validate_content_type_of(:cover_image).allowing('image/png', 'image/jpeg') }
  it { is_expected.to validate_size_of(:cover_image).less_than(16.megabytes) }

  it { is_expected.not_to validate_attached_of(:images) }
  it { is_expected.to validate_content_type_of(:images).allowing('image/png', 'image/jpeg') }
  it { is_expected.to validate_size_of(:images).less_than(16.megabytes) }

  #   ..######...######...#######..########..########..######.
  #   .##....##.##....##.##.....##.##.....##.##.......##....##
  #   .##.......##.......##.....##.##.....##.##.......##......
  #   ..######..##.......##.....##.########..######....######.
  #   .......##.##.......##.....##.##........##.............##
  #   .##....##.##....##.##.....##.##........##.......##....##
  #   ..######...######...#######..##........########..######.

  #   .########..##.....##.########..##.......####..######..##.....##.########.########.
  #   .##.....##.##.....##.##.....##.##........##..##....##.##.....##.##.......##.....##
  #   .##.....##.##.....##.##.....##.##........##..##.......##.....##.##.......##.....##
  #   .########..##.....##.########..##........##...######..#########.######...##.....##
  #   .##........##.....##.##.....##.##........##........##.##.....##.##.......##.....##
  #   .##........##.....##.##.....##.##........##..##....##.##.....##.##.......##.....##
  #   .##.........#######..########..########.####..######..##.....##.########.########.

  describe 'published' do
    context 'when work is not published' do
      let_it_be(:work) { create(:work) }

      it 'can not find work' do
        expect(described_class.published.find_by(id: work.id)).to be_nil
      end
    end

    context 'when work is published' do
      let_it_be(:work) { create(:work, :published) }

      it 'can find work' do
        expect(described_class.published.find_by(id: work.id)).to eq(work)
      end
    end
  end

  #   .##.....##.########.########.##.....##..#######..########...######.
  #   .###...###.##..........##....##.....##.##.....##.##.....##.##....##
  #   .####.####.##..........##....##.....##.##.....##.##.....##.##......
  #   .##.###.##.######......##....#########.##.....##.##.....##..######.
  #   .##.....##.##..........##....##.....##.##.....##.##.....##.......##
  #   .##.....##.##..........##....##.....##.##.....##.##.....##.##....##
  #   .##.....##.########....##....##.....##..#######..########...######.

  #   .....########..##.....##.########..##.......####..######..##.....##.####
  #   .....##.....##.##.....##.##.....##.##........##..##....##.##.....##.####
  #   .....##.....##.##.....##.##.....##.##........##..##.......##.....##.####
  #   .....########..##.....##.########..##........##...######..#########..##.
  #   .....##........##.....##.##.....##.##........##........##.##.....##.....
  #   .###.##........##.....##.##.....##.##........##..##....##.##.....##.####
  #   .###.##.........#######..########..########.####..######..##.....##.####

  describe '.publish!' do
    context 'when work is already published' do
      let_it_be(:work) { create(:work, :published) }

      it 'returns true' do
        expect(work.publish!).to be(true)
      end
    end

    context 'when work is not published' do
      let_it_be(:work) { create(:work) }

      it 'returns true' do
        expect(work.publish!).to be(true)
      end

      it 'update work to published' do
        expect { work.publish! }.to change { work.reload.is_published? }.to(true)
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
    context 'when work is not published' do
      let_it_be(:work) { create(:work) }

      it 'returns true' do
        expect(work.unpublish!).to be(true)
      end
    end

    context 'when work is published' do
      let_it_be(:work) { create(:work, :published) }

      it 'returns true' do
        expect(work.unpublish!).to be(true)
      end

      it 'update work to unpublished' do
        expect { work.unpublish! }.to change { work.reload.is_published? }.to(false)
      end
    end
  end

  #   ......######...#######..##.....##.########.########..........####.##.....##....###.....######...########.........##.....##.########..##......
  #   .....##....##.##.....##.##.....##.##.......##.....##..........##..###...###...##.##...##....##..##...............##.....##.##.....##.##......
  #   .....##.......##.....##.##.....##.##.......##.....##..........##..####.####..##...##..##........##...............##.....##.##.....##.##......
  #   .....##.......##.....##.##.....##.######...########...........##..##.###.##.##.....##.##...####.######...........##.....##.########..##......
  #   .....##.......##.....##..##...##..##.......##...##............##..##.....##.#########.##....##..##...............##.....##.##...##...##......
  #   .###.##....##.##.....##...##.##...##.......##....##...........##..##.....##.##.....##.##....##..##...............##.....##.##....##..##......
  #   .###..######...#######.....###....########.##.....##.#######.####.##.....##.##.....##..######...########.#######..#######..##.....##.########

  describe '.cover_image_url' do
    let_it_be(:work) { create(:work) }

    it 'returns cover_image_url' do
      expect(work.cover_image_url).to be_a(String)
    end
  end

  #   .....####.##.....##....###.....######...########..######..........##.....##.########..##........######.
  #   ......##..###...###...##.##...##....##..##.......##....##.........##.....##.##.....##.##.......##....##
  #   ......##..####.####..##...##..##........##.......##...............##.....##.##.....##.##.......##......
  #   ......##..##.###.##.##.....##.##...####.######....######..........##.....##.########..##........######.
  #   ......##..##.....##.#########.##....##..##.............##.........##.....##.##...##...##.............##
  #   .###..##..##.....##.##.....##.##....##..##.......##....##.........##.....##.##....##..##.......##....##
  #   .###.####.##.....##.##.....##..######...########..######..#######..#######..##.....##.########..######.

  describe '.images_urls' do
    let_it_be(:work) { create(:work, :has_images) }

    it 'returns images_urls' do
      expect(work.images_urls).to be_a(Array)
    end
  end

  #   .....##.....##..######..########.########...........######...#######..##.....##.##....##.########
  #   .....##.....##.##....##.##.......##.....##.........##....##.##.....##.##.....##.###...##....##...
  #   .....##.....##.##.......##.......##.....##.........##.......##.....##.##.....##.####..##....##...
  #   .....##.....##..######..######...########..........##.......##.....##.##.....##.##.##.##....##...
  #   .....##.....##.......##.##.......##...##...........##.......##.....##.##.....##.##..####....##...
  #   .###.##.....##.##....##.##.......##....##..........##....##.##.....##.##.....##.##...###....##...
  #   .###..#######...######..########.##.....##.#######..######...#######...#######..##....##....##...

  describe '.user_count' do
    let_it_be(:work) { create(:work) }
    let_it_be(:random_user_count) { rand(1..3) }

    before_all do
      random_user_count.times do
        copyright = create(:copyright, work:)

        create(:user_copyright, user: create(:user, :published), copyright:)
      end
    end

    it 'returns user_count' do
      expect(work.user_count).to be_a(Integer)
    end

    it 'returns correct user_count' do
      expect(work.user_count).to eq(random_user_count)
    end
  end
end
