# == Schema Information
#
# Table name: release_notes
#
#  id         :uuid             not null, primary key
#  title      :string(191)      not null
#  version    :string(191)      not null
#  created_at :datetime
#  updated_at :datetime
#
require 'rails_helper'

RSpec.describe ReleaseNote do
  it { is_expected.to validate_presence_of(:version) }
  it { is_expected.to validate_presence_of(:title) }
end
