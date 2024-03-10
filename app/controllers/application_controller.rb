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

  # TODO: 要レスポンス確認
  rescue_from ActiveRecord::RecordNotFound do |e|
    render_error(
      status: :not_found,
      resource: e.model,
      errors: [
        {
          field: 'id',
          message: '指定されたIDのリソースが見つかりません。'
        }
      ]
    )
  end

  # TODO: 要レスポンス確認
  rescue_from ActiveRecord::RecordInvalid do |e|
    render_error(
      status: :unprocessable_entity,
      resource: e.record.class.to_s,
      errors: e.record.errors.map do |error|
        {
          field: error.attribute,
          message: error.message
        }
      end
    )
  end

  def render_error(status:, resource:, errors:)
    code = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]

    render json: {
      message: 'Request failed',
      resource:,
      code:,
      errors: errors.map do |error|
        {
          field: error[:field],
          message: error[:message]
        }
      end
    }, status:
  end
end
