# == Schema Information
#
# Table name: assets
#
#  id         :uuid             not null, primary key
#  created_by :uuid
#  name       :string           not null
#  url        :string
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_assets_on_name  (name) UNIQUE
#
require 'rails_helper'

RSpec.describe Asset do
  subject { create(:asset) }

  #   ....###.....######...######...#######...######..####....###....########.####..#######..##....##..######.
  #   ...##.##...##....##.##....##.##.....##.##....##..##....##.##......##.....##..##.....##.###...##.##....##
  #   ..##...##..##.......##.......##.....##.##........##...##...##.....##.....##..##.....##.####..##.##......
  #   .##.....##..######...######..##.....##.##........##..##.....##....##.....##..##.....##.##.##.##..######.
  #   .#########.......##.......##.##.....##.##........##..#########....##.....##..##.....##.##..####.......##
  #   .##.....##.##....##.##....##.##.....##.##....##..##..##.....##....##.....##..##.....##.##...###.##....##
  #   .##.....##..######...######...#######...######..####.##.....##....##....####..#######..##....##..######.

  it { is_expected.to belong_to(:created_user).class_name('User').optional }

  it { is_expected.to have_many(:work_assets) }
  it { is_expected.to have_many(:works).through(:work_assets) }

  #   .##.....##....###....##.......####.########.....###....########.####..#######..##....##..######.
  #   .##.....##...##.##...##........##..##.....##...##.##......##.....##..##.....##.###...##.##....##
  #   .##.....##..##...##..##........##..##.....##..##...##.....##.....##..##.....##.####..##.##......
  #   .##.....##.##.....##.##........##..##.....##.##.....##....##.....##..##.....##.##.##.##..######.
  #   ..##...##..#########.##........##..##.....##.#########....##.....##..##.....##.##..####.......##
  #   ...##.##...##.....##.##........##..##.....##.##.....##....##.....##..##.....##.##...###.##....##
  #   ....###....##.....##.########.####.########..##.....##....##....####..#######..##....##..######.

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }

  it { is_expected.to allow_value(Faker::Internet.url).for(:url) }
  it { is_expected.to allow_value(nil).for(:url) }
  it { is_expected.to allow_value('').for(:url) }
  it { is_expected.not_to allow_value('unpermitted_format').for(:url) }
end
