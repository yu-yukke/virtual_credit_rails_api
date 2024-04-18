module Api
  module V1
    module Auth
      class ConfirmationsController < DeviseTokenAuth::ConfirmationsController
        skip_before_action :authenticate_api_v1_user!

        def show
          # 外部サイトへのリダイレクトで引っかかるのでallow_other_hostを渡して丸ごとオーバーライド
          @resource = resource_class.confirm_by_token(resource_params[:confirmation_token])

          if @resource.errors.empty?
            yield @resource if block_given?

            redirect_header_options = { account_confirmation_success: true }

            if signed_in?(resource_name)
              token = signed_in_resource.create_token
              signed_in_resource.save!

              redirect_headers = build_redirect_headers(token.token,
                                                        token.client,
                                                        redirect_header_options)

              redirect_to_link = signed_in_resource.build_auth_url(redirect_url, redirect_headers)
            else
              redirect_to_link = DeviseTokenAuth::Url.generate(redirect_url, redirect_header_options)
            end

            redirect_to(redirect_to_link, { allow_other_host: true })
          else
            raise ActionController::RoutingError, 'Not Found' unless redirect_url

            redirect_to DeviseTokenAuth::Url.generate(redirect_url, account_confirmation_success: false), { allow_other_host: true }
          end
        end
      end
    end
  end
end
