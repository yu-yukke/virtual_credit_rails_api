module Api
  module V1
    class WorksController < ApplicationController
      skip_before_action :authenticate_api_v1_user!, only: %i[index show]

      before_action :check_page_params, only: %i[index]
      before_action :check_create_params, only: %i[create]

      def index
        works = Work.published.page(params[:page])

        data = ActiveModelSerializers::SerializableResource.new(
          works,
          each_serializer: Api::V1::SimpleWorkSerializer
        ).serializable_hash

        render(
          json: {
            data:,
            meta: pagination(works)
          },
          status: :ok
        )
      end

      def show
        work = current_api_v1_user&.my_works&.find_by(id: params[:id]) || Work.published.find_by(id: params[:id])
        return render_get_error if work.nil?

        data = ActiveModelSerializers::SerializableResource.new(
          work,
          serializer: Api::V1::WorkSerializer,
          current_user: current_api_v1_user
        ).serializable_hash

        render(
          json: {
            data:
          },
          status: :ok
        )
      end

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

      def render_get_error
        render_errors(
          status: :not_found,
          resource: 'Work',
          errors: [
            {
              field: 'id',
              message: '指定したIDを持つ作品が存在しないか、非公開の可能性があります。'
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
