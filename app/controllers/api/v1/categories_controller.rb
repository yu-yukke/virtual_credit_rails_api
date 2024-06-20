module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :check_create_params, only: %i[create]

      def create
        @category = Category.create!(create_params)

        render_create_success
      end

      protected

      def render_create_success
        data = ActiveModelSerializers::SerializableResource.new(
          @category,
          serializer: Api::V1::CategorySerializer
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
        params.require(:category).permit(
          :name
        )
      end

      def check_create_params
        check_required_params(
          resource: 'Category',
          required_params: Category::CREATE_PARAMS,
          requested_params: create_params
        )
      end
    end
  end
end
