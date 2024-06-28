module Api
  module V1
    module Works
      class TagsController < ApplicationController
        before_action :check_create_params, only: %i[create]

        def create
          tag = Tag.find(create_params[:id])
          work = Work.find(params[:work_id])
          work.tags << tag

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
          params.require(:tag).permit(
            :id
          )
        end

        def check_create_params
          check_required_params(
            resource: 'WorkTag',
            required_params: Work::CREATE_WORK_TAG_PARAMS,
            requested_params: create_params
          )
        end
      end
    end
  end
end
