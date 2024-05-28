require 'rails_helper'

RSpec.describe 'Api::V1::Social' do
  #   .########...#######...######..########......##.##....######..########..########....###....########.########
  #   .##.....##.##.....##.##....##....##.........##.##...##....##.##.....##.##.........##.##......##....##......
  #   .##.....##.##.....##.##..........##.......#########.##.......##.....##.##........##...##.....##....##......
  #   .########..##.....##..######.....##.........##.##...##.......########..######...##.....##....##....######..
  #   .##........##.....##.......##....##.......#########.##.......##...##...##.......#########....##....##......
  #   .##........##.....##.##....##....##.........##.##...##....##.##....##..##.......##.....##....##....##......
  #   .##.........#######...######.....##.........##.##....######..##.....##.########.##.....##....##....########

  describe 'POST #create' do
    subject(:request) do
      post api_v1_skills_path, headers:, params:
    end

    let_it_be(:user) { create(:user, :confirmed) }

    context 'when user does not signed-in' do
      let_it_be(:headers) { {} }
      let_it_be(:params) do
        {
          skill: {
            name: Faker::Internet.slug
          }
        }
      end

      it_behaves_like 'unauthorized' do
        before { request }
      end

      it 'does not create a new skill' do
        expect { request }.not_to(change(Skill, :count))
      end
    end

    context 'when lack of name params' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          skill: {
            hoge: 'fuga'
          }
        }
      end

      it_behaves_like 'bad_request' do
        before { request }
      end

      it 'does not create a new skill' do
        expect { request }.not_to(change(Skill, :count))
      end
    end

    context 'when name is nil' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          skill: {
            name: nil
          }
        }
      end

      it_behaves_like 'unprocessable_entity' do
        before { request }
      end

      it 'does not create a new skill' do
        expect { request }.not_to(change(Skill, :count))
      end
    end

    context 'when name is blank' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          skill: {
            name: ''
          }
        }
      end

      it_behaves_like 'unprocessable_entity' do
        before { request }
      end

      it 'does not create a new skill' do
        expect { request }.not_to(change(Skill, :count))
      end
    end

    context 'when name is valid' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          skill: {
            name: Faker::Internet.slug
          }
        }
      end

      it_behaves_like 'created' do
        before { request }
      end

      it 'creates a new skill' do
        expect { request }.to(change(Skill, :count))
      end

      it 'sets created_user to the new skill created' do
        request

        expect(Skill.last.created_user).to eq(user)
      end
    end

    context 'when name is already taken' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          skill: {
            name: create(:skill).name
          }
        }
      end

      it_behaves_like 'unprocessable_entity' do
        before { request }
      end

      it 'does not create a new skill' do
        expect { request }.not_to(change(Skill, :count))
      end
    end
  end
end
