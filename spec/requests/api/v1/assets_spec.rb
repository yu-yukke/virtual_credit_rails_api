require 'rails_helper'

RSpec.describe 'Api::V1::Assets' do
  #   .########...#######...######..########......##.##....######..########..########....###....########.########
  #   .##.....##.##.....##.##....##....##.........##.##...##....##.##.....##.##.........##.##......##....##......
  #   .##.....##.##.....##.##..........##.......#########.##.......##.....##.##........##...##.....##....##......
  #   .########..##.....##..######.....##.........##.##...##.......########..######...##.....##....##....######..
  #   .##........##.....##.......##....##.......#########.##.......##...##...##.......#########....##....##......
  #   .##........##.....##.##....##....##.........##.##...##....##.##....##..##.......##.....##....##....##......
  #   .##.........#######...######.....##.........##.##....######..##.....##.########.##.....##....##....########

  describe 'POST #create' do
    subject(:request) do
      post api_v1_assets_path, headers:, params:
    end

    let_it_be(:user) { create(:user, :confirmed) }

    context 'when user does not signed-in' do
      let_it_be(:headers) { {} }
      let_it_be(:params) do
        {
          asset: {
            name: Faker::Computer.unique.os
          }
        }
      end

      it_behaves_like 'unauthorized' do
        before { request }
      end

      it 'does not create a new asset' do
        expect { request }.not_to(change(Asset, :count))
      end
    end

    context 'when lack of name params' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          asset: {
            url: Faker::Internet.url
          }
        }
      end

      it_behaves_like 'bad_request' do
        before { request }
      end

      it 'does not create a new asset' do
        expect { request }.not_to(change(Asset, :count))
      end
    end

    context 'when name is nil' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          asset: {
            name: nil
          }
        }
      end

      it_behaves_like 'unprocessable_entity' do
        before { request }
      end

      it 'does not create a new asset' do
        expect { request }.not_to(change(Asset, :count))
      end
    end

    context 'when name is blank' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          asset: {
            name: ''
          }
        }
      end

      it_behaves_like 'unprocessable_entity' do
        before { request }
      end

      it 'does not create a new asset' do
        expect { request }.not_to(change(Asset, :count))
      end
    end

    context 'when name is valid' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          asset: {
            name: Faker::Computer.unique.os
          }
        }
      end

      it_behaves_like 'created' do
        before { request }
      end

      it 'creates a new asset' do
        expect { request }.to(change(Asset, :count))
      end

      it 'sets created_user to the new asset created' do
        request

        expect(Asset.last.created_user).to eq(user)
      end
    end

    context 'when name is already taken' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          asset: {
            name: create(:asset).name
          }
        }
      end

      it_behaves_like 'unprocessable_entity' do
        before { request }
      end

      it 'does not create a new asset' do
        expect { request }.not_to(change(Asset, :count))
      end
    end

    context 'when lack of url params' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          asset: {
            name: Faker::Computer.unique.os
          }
        }
      end

      it_behaves_like 'created' do
        before { request }
      end

      it 'creates a new asset' do
        expect { request }.to(change(Asset, :count))
      end

      it 'created a new asset with url as nil' do
        request

        expect(Asset.last.url).to be_nil
      end

      it 'sets created_user to the new asset created' do
        request

        expect(Asset.last.created_user).to eq(user)
      end
    end

    context 'when url is nil' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          asset: {
            name: Faker::Computer.unique.os,
            url: nil
          }
        }
      end

      it_behaves_like 'created' do
        before { request }
      end

      it 'creates a new asset' do
        expect { request }.to(change(Asset, :count))
      end

      it 'created a new asset with url as nil' do
        request

        expect(Asset.last.url).to be_nil
      end

      it 'sets created_user to the new asset created' do
        request

        expect(Asset.last.created_user).to eq(user)
      end
    end

    context 'when url is blank' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          asset: {
            name: Faker::Computer.unique.os,
            url: ''
          }
        }
      end

      it_behaves_like 'created' do
        before { request }
      end

      it 'creates a new asset' do
        expect { request }.to(change(Asset, :count))
      end

      it 'created a new asset with blank url' do
        request

        expect(Asset.last.url).to be_blank
      end

      it 'sets created_user to the new asset created' do
        request

        expect(Asset.last.created_user).to eq(user)
      end
    end

    context 'when url is invalid format' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          asset: {
            name: Faker::Computer.unique.os,
            url: 'invalid_format'
          }
        }
      end

      it_behaves_like 'unprocessable_entity' do
        before { request }
      end

      it 'does not create a new asset' do
        expect { request }.not_to(change(Asset, :count))
      end
    end

    context 'when url is valid' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:url) { Faker::Internet.url }
      let_it_be(:params) do
        {
          asset: {
            name: Faker::Computer.unique.os,
            url:
          }
        }
      end

      it_behaves_like 'created' do
        before { request }
      end

      it 'creates a new asset' do
        expect { request }.to(change(Asset, :count))
      end

      it 'created a new asset with the url' do
        request

        expect(Asset.last.url).to eq(url)
      end

      it 'sets created_user to the new asset created' do
        request

        expect(Asset.last.created_user).to eq(user)
      end
    end
  end
end
