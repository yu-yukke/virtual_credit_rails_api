module Exceptions
  extend ActiveSupport::Concern

  included do
    rescue_from Exception, with: :rescue_500

    def rescue_500(error)
      render(
        json: {
          error: {
            code: 500,
            message: "予期せぬエラーが発生しましたよ。: #{error}"
          }
        },
        status: :internal_server_error
      )

      Rails.logger.error(error)
    end
  end
end
