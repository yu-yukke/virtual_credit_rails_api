module Api
  module V1
    class UsersMeController < ApplicationController
      before_action :check_update_params, only: :update

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
        params.permit(:name, :slug, :description, :image)
      end

      def check_update_params
        check_required_params(
          resource: 'User',
          required_params: User::UPDATE_PARAMS,
          requested_params: update_params
        )
      end
    end
  end
end
