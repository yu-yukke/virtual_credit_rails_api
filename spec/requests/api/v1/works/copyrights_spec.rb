require 'rails_helper'

RSpec.describe 'Api::V1::Works::Copyrights' do
  #   .########...#######...######..########......##.##....######..########..########....###....########.########
  #   .##.....##.##.....##.##....##....##.........##.##...##....##.##.....##.##.........##.##......##....##......
  #   .##.....##.##.....##.##..........##.......#########.##.......##.....##.##........##...##.....##....##......
  #   .########..##.....##..######.....##.........##.##...##.......########..######...##.....##....##....######..
  #   .##........##.....##.......##....##.......#########.##.......##...##...##.......#########....##....##......
  #   .##........##.....##.##....##....##.........##.##...##....##.##....##..##.......##.....##....##....##......
  #   .##.........#######...######.....##.........##.##....######..##.....##.########.##.....##....##....########

  describe 'POST #create' do
    subject(:request) do
      post api_v1_work_copyrights_path(work_id), headers:, params:
    end

    let_it_be(:user) { create(:user, :confirmed) }
    let_it_be(:work) { create(:work) }
    let(:work_id) { work.id }

    context 'when user does not signed-in' do
      let_it_be(:headers) { {} }
      let_it_be(:params) do
        {
          copyright: {
            name: 'copyright'
          }
        }
      end

      it_behaves_like 'unauthorized' do
        before { request }
      end

      it 'does not create new copyright' do
        expect { request }.not_to(change(Copyright, :count))
      end
    end

    context 'when work is not found' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          copyright: {
            name: 'copyright'
          }
        }
      end
      let(:work_id) { 'invalid-work-id' }

      it_behaves_like 'not_found' do
        before { request }
      end

      it 'does not create new copyright' do
        expect { request }.not_to(change(Copyright, :count))
      end
    end

    context 'when lack of name params' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          copyright: {
            hoge: 'fuga'
          }
        }
      end

      it_behaves_like 'bad_request' do
        before { request }
      end

      it 'does not create new copyright' do
        expect { request }.not_to(change(Copyright, :count))
      end
    end

    context 'when name is nil' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          copyright: {
            name: nil
          }
        }
      end

      it_behaves_like 'unprocessable_entity' do
        before { request }
      end

      it 'does not create new copyright' do
        expect { request }.not_to(change(Copyright, :count))
      end
    end

    context 'when the work already has the copyright' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          copyright: {
            name: 'copyright'
          }
        }
      end

      before_all do
        create(:copyright, work:, name: 'copyright')
      end

      it_behaves_like 'unprocessable_entity' do
        before { request }
      end

      it 'does not create new copyright' do
        expect { request }.not_to(change(Copyright, :count))
      end
    end

    context 'when params is valid' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          copyright: {
            name: 'copyright'
          }
        }
      end

      it_behaves_like 'created' do
        before { request }
      end

      it 'creates new copyright' do
        expect { request }.to change(Copyright, :count).by(1)
      end

      it 'creates the copyright by the user' do
        request

        expect(work.copyrights.first.created_user).to eq(user)
      end
    end
  end
end
