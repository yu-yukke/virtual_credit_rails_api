module Api
  module V1
    class ReleaseNotesController < ApplicationController
      before_action :check_page_params

      def index
        release_notes = ReleaseNote.all.page(params[:page])

        data = ActiveModelSerializers::SerializableResource.new(
          release_notes,
          each_serializer: Api::V1::ReleaseNoteSerializer,
          include: '**'
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

        render_400(
          resource: 'ReleaseNote',
          message: 'wrong type of page params ( given string, expected integer)'
        )
      end
    end
  end
end
