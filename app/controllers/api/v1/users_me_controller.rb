module Api
  module V1
    class UsersMeController < ApplicationController
      def show
        data = ActiveModelSerializers::SerializableResource.new(
          current_api_v1_user,
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
