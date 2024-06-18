module Api
  module V1
    module Works
      class WorkImagesController < ApplicationController
        before_action :check_create_params, only: %i[create]

        def create
          @work = current_api_v1_user.my_works.find(params[:work_id])
          @work.images.attach(create_params[:content])
          @work.save!

          if @work.images.attached?
            render_create_success
          else
            render_create_error
          end
        end

        protected

        def render_create_success
          image = @work.images.blobs.order(created_at: :desc).first

          render(
            json: {
              data: {
                url: url_for(image)
              }
            },
            status: :created
          )
        end

        def render_create_error
          render_errors(
            status: :unprocessable_entity,
            resource: 'WorkImage',
            errors: ['作品への画像の紐付けに失敗しました。画像データが正しく送信されているか確認してください。']
          )
        end

        private

        def create_params
          params.require(:image).permit(
            :content
          )
        end

        def check_create_params
          check_required_params(
            resource: 'WorkImage',
            required_params: Work::CREATE_WORK_IMAGE_PARAMS,
            requested_params: create_params
          )
        end
      end
    end
  end
end
