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
        form = Forms::Users::UpdateForm.new(current_api_v1_user, update_params)
        form.save!

        render_update_success
      end

      protected

      def render_update_success
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
