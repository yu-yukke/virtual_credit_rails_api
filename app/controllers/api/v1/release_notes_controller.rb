module Api
  module V1
    class ReleaseNotesController < ApplicationController
      def index
        release_notes = ReleaseNote.all.page(params[:page])

        items = ActiveModelSerializers::SerializableResource.new(
          release_notes,
          each_serializer: Api::V1::ReleaseNoteSerializer,
          include: '**'
        ).serializable_hash

        render(
          json: {
            items:,
            meta: pagination(release_notes)
          },
          status: :ok
        )
      end
    end
  end
end
