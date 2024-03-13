module Api
  module V1
    module Auth
      class RegistrationsController < DeviseTokenAuth::RegistrationsController
        skip_before_action :validate_sign_up_params, only: :create
        before_action :check_registration_params, only: :create
        before_action :check_duplicated_email, only: :create

        private

        def registration_params
          params.permit(
            :email,
            :password,
            :password_confirmation
          )
        end

        def check_registration_params
          check_required_params(
            resource: 'User',
            required_params: User::REGISTRATION_PARAMS,
            requested_params: registration_params
          )
        end

        def check_duplicated_email
          return unless User.exists?(email: registration_params[:email])

          render_errors(
            status: :conflict,
            resource: 'User',
            errors: [
              {
                field: 'email',
                message: '既に使用されているメールアドレスです。'
              }
            ]
          )
        end

        protected

        def render_create_success
          data = ActiveModelSerializers::SerializableResource.new(
            @resource,
            serializer: Api::V1::NewUserSerializer
          ).serializable_hash

          render(
            json: { data: }, status: :created
          )
        end

        def render_create_error
          render_errors(
            status: :unprocessable_entity,
            resource: @resource.class.name,
            errors: @resource.errors.to_hash.map.with_index do |error, index|
              {
                field: error[0].to_s,
                message: @resource.errors.full_messages[index]
              }
            end
          )
        end
      end
    end
  end
end
