module Api
  module V1
    class TagsController < ApplicationController
      before_action :check_create_params, only: %i[create]

      def create
        @tag = Tag.create!(create_params)

        render_create_success
      end

      protected

      def render_create_success
        data = ActiveModelSerializers::SerializableResource.new(
          @tag,
          serializer: Api::V1::TagSerializer
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
        params.require(:tag).permit(
          :name
        )
      end

      def check_create_params
        check_required_params(
          resource: 'Tag',
          required_params: Tag::CREATE_PARAMS,
          requested_params: create_params
        )
      end
    end
  end
end
