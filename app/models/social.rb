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
class Social < ApplicationRecord
  belongs_to :user

  WEBSITE_REGEXP = %r{\Ahttps?://(?:www\.)?(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(?::\d+)?(?:/\S*)?\z}

  validates :website_url, format: { with: WEBSITE_REGEXP }, allow_blank: true
end
