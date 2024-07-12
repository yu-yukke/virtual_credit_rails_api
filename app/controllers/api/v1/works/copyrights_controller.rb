module Api
  module V1
    module Works
      class CopyrightsController < ApplicationController
        before_action :check_create_params, only: %i[create]

        def create
          work = Work.find(params[:work_id])
          @copyright = work.copyrights.create!(create_params)

          render_create_success
        end

        protected

        def render_create_success
          data = ActiveModelSerializers::SerializableResource.new(
            @copyright,
            serializer: Api::V1::CopyrightSerializer
          ).serializable_hash

          render(
            json: {
              data:
            },
            status: :created
          )
        end

        private

        def create_params
          params.require(:copyright).permit(
            :name
          )
        end

        def check_create_params
          check_required_params(
            resource: 'Copyright',
            required_params: Copyright::CREATE_PARAMS,
            requested_params: create_params
          )
        end
      end
    end
  end
end
