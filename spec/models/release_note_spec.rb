# == Schema Information
#
# Table name: release_notes
#
#  id          :uuid             not null, primary key
#  description :text             not null
#  title       :string           not null
#  version     :string           not null
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_release_notes_on_version  (version) UNIQUE
#
require 'rails_helper'

RSpec.describe ReleaseNote do
  subject { create(:release_note) }

  #   .##.....##....###....##.......####.########.....###....########.####..#######..##....##..######.
  #   .##.....##...##.##...##........##..##.....##...##.##......##.....##..##.....##.###...##.##....##
  #   .##.....##..##...##..##........##..##.....##..##...##.....##.....##..##.....##.####..##.##......
  #   .##.....##.##.....##.##........##..##.....##.##.....##....##.....##..##.....##.##.##.##..######.
  #   ..##...##..#########.##........##..##.....##.#########....##.....##..##.....##.##..####.......##
  #   ...##.##...##.....##.##........##..##.....##.##.....##....##.....##..##.....##.##...###.##....##
  #   ....###....##.....##.########.####.########..##.....##....##....####..#######..##....##..######.

  it { is_expected.to validate_presence_of(:version) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:description) }

  it { is_expected.to validate_uniqueness_of(:version).case_insensitive }

  #   .##.....##.########.########.##.....##..#######..########...######.
  #   .###...###.##..........##....##.....##.##.....##.##.....##.##....##
  #   .####.####.##..........##....##.....##.##.....##.##.....##.##......
  #   .##.###.##.######......##....#########.##.....##.##.....##..######.
  #   .##.....##.##..........##....##.....##.##.....##.##.....##.......##
  #   .##.....##.##..........##....##.....##.##.....##.##.....##.##....##
  #   .##.....##.########....##....##.....##..#######..########...######.

  #   ..######..########.##.......########.....##..........###....########.########..######..########
  #   .##....##.##.......##.......##...........##.........##.##......##....##.......##....##....##...
  #   .##.......##.......##.......##...........##........##...##.....##....##.......##..........##...
  #   ..######..######...##.......######.......##.......##.....##....##....######....######.....##...
  #   .......##.##.......##.......##...........##.......#########....##....##.............##....##...
  #   .##....##.##.......##.......##.......###.##.......##.....##....##....##.......##....##....##...
  #   ..######..########.########.##.......###.########.##.....##....##....########..######.....##...

  describe 'self.latest' do
    let_it_be(:release_note) { create(:release_note, version: '3.12.18') }

    before do
      create(:release_note, version: '3.12.17')
      create(:release_note, version: '2.0.7')
      create(:release_note, version: '1.3.11')
    end

    it 'returns the latest release note' do
      expect(described_class.latest).to eq(release_note)
    end
  end
end
