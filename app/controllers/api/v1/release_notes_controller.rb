module Api
  module V1
    class ReleaseNotesController < ApplicationController
      before_action :check_page_params

      def index
        release_notes = ReleaseNote.all.page(params[:page])

        data = ActiveModelSerializers::SerializableResource.new(
          release_notes,
          each_serializer: Api::V1::ReleaseNoteSerializer
        ).serializable_hash

        render(
          json: {
            data:,
            meta: pagination(release_notes)
          },
          status: :ok
        )
      end

      private

      def check_page_params
        return if params[:page].nil?
        return if is_pagination_params_valid

        render_errors(
          status: :bad_request,
          resource: 'ReleaseNote',
          errors: [
            {
              field: 'page',
              message: 'pageは数字で入力してください。'
            }
          ]
        )
      end
    end
  end
end
