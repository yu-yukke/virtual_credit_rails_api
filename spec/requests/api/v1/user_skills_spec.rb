require 'rails_helper'

RSpec.describe 'Api::V1::UserSkills' do
  #   .########...#######...######..########......##.##....######..########..########....###....########.########
  #   .##.....##.##.....##.##....##....##.........##.##...##....##.##.....##.##.........##.##......##....##......
  #   .##.....##.##.....##.##..........##.......#########.##.......##.....##.##........##...##.....##....##......
  #   .########..##.....##..######.....##.........##.##...##.......########..######...##.....##....##....######..
  #   .##........##.....##.......##....##.......#########.##.......##...##...##.......#########....##....##......
  #   .##........##.....##.##....##....##.........##.##...##....##.##....##..##.......##.....##....##....##......
  #   .##.........#######...######.....##.........##.##....######..##.....##.########.##.....##....##....########

  describe 'POST #create' do
    subject(:request) do
      post api_v1_user_skills_path, headers:, params:
    end

    context 'when user does not signed-in' do
      let_it_be(:user) { create(:user, :confirmed) }
      let_it_be(:headers) { {} }
      let_it_be(:params) do
        {
          user_skill: {
            skill_id: create(:skill).id
          }
        }
      end

      it_behaves_like 'unauthorized' do
        before { request }
      end

      it 'does not create a new user_skill' do
        expect { request }.not_to(change(UserSkill, :count))
      end
    end

    context 'when user does not be confirmed' do
      let_it_be(:user) { create(:user, :new_user) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          user_skill: {
            skill_id: create(:skill).id
          }
        }
      end

      it_behaves_like 'unauthorized' do
        before { request }
      end

      it 'does not create a new user_skill' do
        expect { request }.not_to(change(UserSkill, :count))
      end
    end

    context 'when lack of skill_id params' do
      let_it_be(:user) { create(:user, :confirmed) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          user_skill: {
            hoge: 'fuga'
          }
        }
      end

      it_behaves_like 'bad_request' do
        before { request }
      end

      it 'does not create a new user_skill' do
        expect { request }.not_to(change(UserSkill, :count))
      end
    end

    context 'when skill_id is not exist' do
      let_it_be(:user) { create(:user, :confirmed) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          user_skill: {
            skill_id: 'skill-id-not-existed'
          }
        }
      end

      it_behaves_like 'not_found' do
        before { request }
      end

      it 'does not create a new user_skill' do
        expect { request }.not_to(change(UserSkill, :count))
      end
    end

    context 'when user already has the skill' do
      let_it_be(:user) { create(:user, :confirmed) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:skill) { create(:skill) }
      let_it_be(:params) do
        {
          user_skill: {
            skill_id: skill.id
          }
        }
      end

      before_all do
        create(:user_skill, user:, skill:)
      end

      it_behaves_like 'unprocessable_entity' do
        before { request }
      end

      it 'does not create a new user_skill' do
        expect { request }.not_to(change(UserSkill, :count))
      end
    end

    context 'when user does not have the skill' do
      let_it_be(:user) { create(:user, :confirmed) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          user_skill: {
            skill_id: create(:skill).id
          }
        }
      end

      it_behaves_like 'created' do
        before { request }
      end

      it 'creates a new user_skill' do
        expect { request }.to(change(UserSkill, :count).by(1))
      end
    end
  end
end
