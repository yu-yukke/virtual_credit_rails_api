module Api
  module V1
    class AssetsController < ApplicationController
      before_action :check_create_params, only: %i[create]

      def create
        @asset = Asset.create!(create_params)

        render_create_success
      end

      protected

      def render_create_success
        data = ActiveModelSerializers::SerializableResource.new(
          @asset,
          serializer: Api::V1::AssetSerializer
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
        params.require(:asset).permit(
          :name,
          :url
        )
      end

      def check_create_params
        check_required_params(
          resource: 'Asset',
          required_params: Asset::CREATE_PARAMS,
          requested_params: create_params
        )
      end
    end
  end
end
