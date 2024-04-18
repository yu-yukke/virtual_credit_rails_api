module Api
  module V1
    module Auth
      class SessionsController < DeviseTokenAuth::SessionsController
        skip_before_action :authenticate_api_v1_user!

        protected

        def render_create_success
          data = ActiveModelSerializers::SerializableResource.new(
            @resource,
            serializer: Api::V1::UsersMeSerializer
          ).serializable_hash

          render(
            json: {
              data:
            },
            status: :ok
          )
        end
      end
    end
  end
end
