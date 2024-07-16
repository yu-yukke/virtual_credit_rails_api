# == Schema Information
#
# Table name: socials
#
#  id          :uuid             not null, primary key
#  website_url :string
#  created_at  :datetime
#  updated_at  :datetime
#  user_id     :uuid             not null
#  x_id        :string
#
# Indexes
#
#  index_socials_on_user_id  (user_id)
#
require 'rails_helper'

RSpec.describe Social do
  subject { create(:social) }

  #   ....###.....######...######...#######...######..####....###....########.####..#######..##....##..######.
  #   ...##.##...##....##.##....##.##.....##.##....##..##....##.##......##.....##..##.....##.###...##.##....##
  #   ..##...##..##.......##.......##.....##.##........##...##...##.....##.....##..##.....##.####..##.##......
  #   .##.....##..######...######..##.....##.##........##..##.....##....##.....##..##.....##.##.##.##..######.
  #   .#########.......##.......##.##.....##.##........##..#########....##.....##..##.....##.##..####.......##
  #   .##.....##.##....##.##....##.##.....##.##....##..##..##.....##....##.....##..##.....##.##...###.##....##
  #   .##.....##..######...######...#######...######..####.##.....##....##....####..#######..##....##..######.

  it { is_expected.to belong_to(:user) }

  #   .##.....##....###....##.......####.########.....###....########.####..#######..##....##..######.
  #   .##.....##...##.##...##........##..##.....##...##.##......##.....##..##.....##.###...##.##....##
  #   .##.....##..##...##..##........##..##.....##..##...##.....##.....##..##.....##.####..##.##......
  #   .##.....##.##.....##.##........##..##.....##.##.....##....##.....##..##.....##.##.##.##..######.
  #   ..##...##..#########.##........##..##.....##.#########....##.....##..##.....##.##..####.......##
  #   ...##.##...##.....##.##........##..##.....##.##.....##....##.....##..##.....##.##...###.##....##
  #   ....###....##.....##.########.####.########..##.....##....##....####..#######..##....##..######.

  it { is_expected.to allow_value(Faker::Internet.url).for(:website_url) }
  it { is_expected.to allow_value(nil).for(:website_url) }
  it { is_expected.to allow_value('').for(:website_url) }
  it { is_expected.not_to allow_value('unpermitted_format').for(:website_url) }

  it { is_expected.to allow_value(Faker::Internet.slug).for(:x_id) }
  it { is_expected.to allow_value(nil).for(:x_id) }
  it { is_expected.to allow_value('').for(:x_id) }
end
