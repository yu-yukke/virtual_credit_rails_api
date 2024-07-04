module Api
  module V1
    module Works
      class AssetsController < ApplicationController
        before_action :check_create_params, only: %i[create]

        def create
          asset = Asset.find(create_params[:id])
          work = Work.find(params[:work_id])
          work.assets << asset

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
          params.require(:asset).permit(
            :id
          )
        end

        def check_create_params
          check_required_params(
            resource: 'WorkAsset',
            required_params: Work::CREATE_WORK_ASSET_PARAMS,
            requested_params: create_params
          )
        end
      end
    end
  end
end
