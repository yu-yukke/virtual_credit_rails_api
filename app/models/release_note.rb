# == Schema Information
#
# Table name: release_notes
#
#  id         :uuid             not null, primary key
#  version    :string(191)      not null
#  title      :string(191)      not null
#  created_at :datetime
#  updated_at :datetime
#
class ReleaseNote < ApplicationRecord
  with_options presence: true do
    validates :version
    validates :title
  end

  def hoge
    Rails.loger.debug 'hoge'
  end
end
