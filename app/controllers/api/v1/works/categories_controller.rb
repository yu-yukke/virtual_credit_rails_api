module Api
  module V1
    module Works
      class CategoriesController < ApplicationController
        before_action :check_create_params, only: %i[create]

        def create
          category = Category.find(create_params[:id])
          work = Work.find(params[:work_id])
          work.categories << category

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
          params.require(:category).permit(
            :id
          )
        end

        def check_create_params
          check_required_params(
            resource: 'WorkCategory',
            required_params: Work::CREATE_WORK_CATEGORY_PARAMS,
            requested_params: create_params
          )
        end
      end
    end
  end
end
