module Api
  module V1
    module Auth
      class SessionsController < DeviseTokenAuth::SessionsController
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
