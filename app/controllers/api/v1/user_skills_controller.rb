module Api
  module V1
    class UserSkillsController < ApplicationController
      before_action :check_create_params, only: %i[create]

      def create
        skill = Skill.find(create_params[:skill_id])
        @user_skill = current_api_v1_user.user_skills.create!(skill:)

        render_create_success
      end

      protected

      def render_create_success
        data = ActiveModelSerializers::SerializableResource.new(
          @user_skill,
          serializer: Api::V1::UserSkillSerializer
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
        params.require(:user_skill).permit(
          :skill_id
        )
      end

      def check_create_params
        check_required_params(
          resource: 'UserSkill',
          required_params: UserSkill::CREATE_PARAMS,
          requested_params: create_params
        )
      end
    end
  end
end
