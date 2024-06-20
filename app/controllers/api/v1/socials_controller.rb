module Api
  module V1
    class SocialsController < ApplicationController
      def update
        @social = current_api_v1_user.social
        @social.update!(update_params)

        render_update_success
      end

      protected

      def render_update_success
        data = ActiveModelSerializers::SerializableResource.new(
          @social,
          serializer: Api::V1::SocialSerializer
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
        params.require(:social).permit(
          :website_url,
          :x_id
        )
      end
    end
  end
end
