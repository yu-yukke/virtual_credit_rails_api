class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  include Pagination
  include Exceptions

  before_action :camelcase_to_snakecase
  before_action :authenticate_api_v1_user!
  before_action :set_current_user

  # TODO: 要レスポンス確認
  rescue_from ActiveRecord::RecordNotFound do |e|
    render_errors(
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

  rescue_from ActiveRecord::RecordInvalid do |e|
    render_errors(
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

  def camelcase_to_snakecase
    params.deep_transform_keys!(&:underscore)
  end

  def is_pagination_params_valid
    params[:page].to_i.to_s == params[:page]
  end

  def set_current_user
    Current.user = current_api_v1_user
  end

  private

  def check_required_params(resource:, required_params:, requested_params:)
    missing_params = required_params - requested_params.keys
    return if missing_params.empty?

    render_errors(
      status: :bad_request,
      resource:,
      errors: missing_params.map do |params|
        {
          field: params,
          message: "#{params} は必須パラメータです。"
        }
      end
    )
  end

  protected

  def render_errors(status:, resource:, errors:)
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
