module Api
  module V1
    module Works
      class LikesController < ApplicationController
        def create
          work = Work.find(params[:work_id])
          work.likes.create!(user: current_api_v1_user)

          render_create_success
        end

        protected

        def render_create_success
          render(
            status: :no_content
          )
        end
      end
    end
  end
end
