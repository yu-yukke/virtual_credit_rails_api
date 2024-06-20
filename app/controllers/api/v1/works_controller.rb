module Api
  module V1
    class WorksController < ApplicationController
      before_action :check_create_params, only: %i[create]

      def create
        @work = current_api_v1_user.my_works.create!(create_params)

        render_create_success
      rescue ActiveSupport::MessageVerifier::InvalidSignature
        render_create_error
      end

      protected

      def render_create_success
        data = ActiveModelSerializers::SerializableResource.new(
          @work,
          serializer: Api::V1::SimpleWorkSerializer
        ).serializable_hash

        render(
          json: {
            data:
          },
          status: :created
        )
      end

      def render_create_error
        render_errors(
          status: :unprocessable_entity,
          resource: 'Work',
          errors: [
            {
              field: 'cover_image',
              message: 'カバー画像が正しくアップロードされませんでした。'
            }
          ]
        )
      end

      private

      def create_params
        params.require(:work).permit(
          :title,
          :description,
          :cover_image
        )
      end

      def check_create_params
        check_required_params(
          resource: 'Work',
          required_params: Work::CREATE_PARAMS,
          requested_params: create_params
        )
      end
    end
  end
end
