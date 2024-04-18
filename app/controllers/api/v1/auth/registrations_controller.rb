module Api
  module V1
    module Auth
      class RegistrationsController < DeviseTokenAuth::RegistrationsController
        skip_before_action :authenticate_api_v1_user!
        skip_before_action :validate_sign_up_params, only: :create
        before_action :check_registration_params, only: :create

        private

        def registration_params
          params.permit(
            :email,
            :password,
            :password_confirmation,
            :confirm_success_url
          )
        end

        def check_registration_params
          check_required_params(
            resource: 'User',
            required_params: User::REGISTRATION_PARAMS,
            requested_params: registration_params
          )
        end
      end
    end
  end
end
