module Api
  module V1
    module Works
      module Copyrights
        class UsersController < ApplicationController
          before_action :check_create_params, only: %i[create]

          def create
            work = Work.find(params[:work_id])
            copyright = work.copyrights.find(params[:copyright_id])
            user = User.published.find(create_params[:id])
            copyright.users << user

            render_create_success
          end

          protected

          def render_create_success
            render(
              status: :no_content
            )
          end

          private

          def create_params
            params.require(:user).permit(
              :id
            )
          end

          def check_create_params
            check_required_params(
              resource: 'UserCopyright',
              required_params: Copyright::CREATE_USER_COPYRIGHT_PARAMS,
              requested_params: create_params
            )
          end
        end
      end
    end
  end
end
