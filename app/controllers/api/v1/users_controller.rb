module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate_api_v1_user!, only: %i[index]

      before_action :check_page_params, only: %i[index]

      def index
        users = User.published.page(params[:page])

        data = ActiveModelSerializers::SerializableResource.new(
          users,
          each_serializer: Api::V1::UserSerializer
        ).serializable_hash

        render(
          json: {
            data:,
            meta: pagination(users)
          },
          status: :ok
        )
      end
    end
  end
end
