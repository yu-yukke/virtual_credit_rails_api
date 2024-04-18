require 'rails_helper'

RSpec.describe 'Api::V1::UsersMe' do
  describe 'GET #show' do
    subject(:request) do
      get me_api_v1_users_path, headers:
    end

    let_it_be(:user) { create(:user, :confirmed) }

    context 'when user does not signed-in' do
      let_it_be(:headers) { {} }

      it_behaves_like 'unauthorized' do
        before { request }
      end
    end

    context 'when user signed-in' do
      let_it_be(:headers) { sign_in(user) }

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns user correctly' do
        request
        body = response.parsed_body

        expect(body['data']['id']).to eq(user.id)
      end
    end
  end
end
