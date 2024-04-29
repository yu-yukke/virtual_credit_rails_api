require 'rails_helper'

RSpec.describe 'Api::V1::Auth::Sessions' do
  #   .########...#######...######..########......##.##....######..########..########....###....########.########
  #   .##.....##.##.....##.##....##....##.........##.##...##....##.##.....##.##.........##.##......##....##......
  #   .##.....##.##.....##.##..........##.......#########.##.......##.....##.##........##...##.....##....##......
  #   .########..##.....##..######.....##.........##.##...##.......########..######...##.....##....##....######..
  #   .##........##.....##.......##....##.......#########.##.......##...##...##.......#########....##....##......
  #   .##........##.....##.##....##....##.........##.##...##....##.##....##..##.......##.....##....##....##......
  #   .##.........#######...######.....##.........##.##....######..##.....##.########.##.....##....##....########

  describe 'POST #create' do
    subject(:request) do
      post api_v1_user_session_path, params:
    end

    context 'with valid params of confirmed new user' do
      let_it_be(:user) { create(:user, :new_user, :confirmed) }
      let_it_be(:params) do
        {
          email: user.email,
          password: user.password
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end
    end

    context 'with valid params of confirmed user' do
      let_it_be(:user) { create(:user, :confirmed) }
      let_it_be(:params) do
        {
          email: user.email,
          password: user.password
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end
    end

    context 'with valid params of activated user' do
      let_it_be(:user) { create(:user, :activated) }
      let_it_be(:params) do
        {
          email: user.email,
          password: user.password
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end
    end

    context 'with valid params of published user' do
      let_it_be(:user) { create(:user, :published) }
      let_it_be(:params) do
        {
          email: user.email,
          password: user.password
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end
    end
  end
end
