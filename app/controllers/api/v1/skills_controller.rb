module Api
  module V1
    class SkillsController < ApplicationController
      skip_before_action :authenticate_api_v1_user!, only: %i[index]
      before_action :check_create_params, only: %i[create]

      def index
        skills = Skill.all.sort_by { |skill| -skill.user_count }

        data = ActiveModelSerializers::SerializableResource.new(
          skills,
          each_serializer: Api::V1::SkillWithUserCountSerializer
        ).serializable_hash

        render(
          json: {
            data:
          },
          status: :ok
        )
      end

      def create
        skill = Skill.create!(create_params)

        data = ActiveModelSerializers::SerializableResource.new(
          skill,
          serializer: Api::V1::SkillSerializer
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
        params.require(:skill).permit(
          :name
        )
      end

      def check_create_params
        check_required_params(
          resource: 'Skill',
          required_params: Skill::CREATE_PARAMS,
          requested_params: create_params
        )
      end
    end
  end
end
