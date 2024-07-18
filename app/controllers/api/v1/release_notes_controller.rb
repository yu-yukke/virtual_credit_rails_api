module Api
  module V1
    class ReleaseNotesController < ApplicationController
      skip_before_action :authenticate_api_v1_user!

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
    end
  end
end
