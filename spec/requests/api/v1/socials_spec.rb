require 'rails_helper'

RSpec.describe 'Api::V1::Social' do
  #   .########.....###....########..######..##.....##......##.##...##.....##.########..########.....###....########.########
  #   .##.....##...##.##......##....##....##.##.....##......##.##...##.....##.##.....##.##.....##...##.##......##....##......
  #   .##.....##..##...##.....##....##.......##.....##....#########.##.....##.##.....##.##.....##..##...##.....##....##......
  #   .########..##.....##....##....##.......#########......##.##...##.....##.########..##.....##.##.....##....##....######..
  #   .##........#########....##....##.......##.....##....#########.##.....##.##........##.....##.#########....##....##......
  #   .##........##.....##....##....##....##.##.....##......##.##...##.....##.##........##.....##.##.....##....##....##......
  #   .##........##.....##....##.....######..##.....##......##.##....#######..##........########..##.....##....##....########

  describe 'PATCH #update' do
    subject(:request) do
      patch api_v1_social_path, headers:, params:
    end

    let_it_be(:user) { create(:user, :confirmed) }
    let_it_be(:social) { user.social }

    context 'when user does not signed-in' do
      let_it_be(:headers) { {} }
      let_it_be(:params) do
        {
          social: {
            website_url: Faker::Internet.url,
            x_id: Faker::Internet.slug
          }
        }
      end

      it_behaves_like 'unauthorized' do
        before { request }
      end

      it 'does not change website_url of the social' do
        expect { request }.not_to(change { social.reload.website_url })
      end

      it 'does not change x_id of the social' do
        expect { request }.not_to(change { social.reload.x_id })
      end
    end

    context 'with changing website_url of the social' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          social: {
            website_url: Faker::Internet.url
          }
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes website_url of the social' do
        previous_website_url = social.website_url

        expect { request }.to(change { social.reload.website_url }.from(previous_website_url).to(params[:social][:website_url]))
      end
    end

    context 'with changing website_url of the social to nil' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          social: {
            website_url: nil
          }
        }
      end

      before_all do
        social.update!(website_url: Faker::Internet.url)
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes website_url of the social' do
        previous_website_url = social.website_url

        expect { request }.to(change { social.reload.website_url }.from(previous_website_url).to(params[:social][:website_url]))
      end
    end

    context 'with changing website_url of the social to blank' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          social: {
            website_url: ''
          }
        }
      end

      before_all do
        social.update!(website_url: Faker::Internet.url)
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes website_url of the social' do
        previous_website_url = social.website_url

        expect { request }.to(change { social.reload.website_url }.from(previous_website_url).to(params[:social][:website_url]))
      end
    end

    context 'with changing website_url of the social to unpermitted format' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          social: {
            website_url: 'unpermitted_format'
          }
        }
      end

      it_behaves_like 'unprocessable entity' do
        before { request }
      end

      it 'does not change website_url of the social' do
        expect { request }.not_to(change { social.reload.website_url })
      end
    end

    context 'with changing x_id of the social' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          social: {
            x_id: Faker::Internet.slug
          }
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes x_id of the social' do
        previous_x_id = social.x_id

        expect { request }.to(change { social.reload.x_id }.from(previous_x_id).to(params[:social][:x_id]))
      end
    end

    context 'with changing x_id of the social to nil' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          social: {
            x_id: nil
          }
        }
      end

      before_all do
        social.update!(x_id: Faker::Internet.slug)
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes x_id of the social' do
        previous_x_id = social.x_id

        expect { request }.to(change { social.reload.x_id }.from(previous_x_id).to(params[:social][:x_id]))
      end
    end

    context 'with changing x_id of the social to blank' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          social: {
            x_id: ''
          }
        }
      end

      before_all do
        social.update!(x_id: Faker::Internet.slug)
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes x_id of the social' do
        previous_x_id = social.x_id

        expect { request }.to(change { social.reload.x_id }.from(previous_x_id).to(params[:social][:x_id]))
      end
    end
  end
end
