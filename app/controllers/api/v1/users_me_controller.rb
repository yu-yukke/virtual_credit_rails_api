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

      def update
        current_api_v1_user.update!(update_params)

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

      private

      def update_params
        params.require(:user).permit(
          :name,
          :slug,
          :description,
          :thumbnail_image
        )
      end
    end
  end
end
