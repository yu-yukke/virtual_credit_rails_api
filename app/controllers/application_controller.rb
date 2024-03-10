class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  include Pagination
  include Exceptions

  before_action :camelcase_to_snakecase

  def camelcase_to_snakecase
    params.deep_transform_keys!(&:underscore)
  end

  def is_pagination_params_valid
    params[:page].to_i.to_s == params[:page]
  end

  def render_400(resource:, message:)
    render json: {
      message: 'Request failed',
      code: 400,
      errors: [
        {
          resource:,
          message:
        }
      ]
    }, status: :bad_request
  end
end
