# modelからincludeすればcreated_userにログイン中のユーザーを自動的に挿入する

module CreatorTracking
  extend ActiveSupport::Concern

  included do
    before_create :set_created_by
  end

  private

  def set_created_by
    self.created_user = Current.user if Current.user
  end
end
