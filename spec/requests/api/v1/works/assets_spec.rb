require 'rails_helper'

RSpec.describe 'Api::V1::Works::Assets' do
  #   .########...#######...######..########......##.##....######..########..########....###....########.########
  #   .##.....##.##.....##.##....##....##.........##.##...##....##.##.....##.##.........##.##......##....##......
  #   .##.....##.##.....##.##..........##.......#########.##.......##.....##.##........##...##.....##....##......
  #   .########..##.....##..######.....##.........##.##...##.......########..######...##.....##....##....######..
  #   .##........##.....##.......##....##.......#########.##.......##...##...##.......#########....##....##......
  #   .##........##.....##.##....##....##.........##.##...##....##.##....##..##.......##.....##....##....##......
  #   .##.........#######...######.....##.........##.##....######..##.....##.########.##.....##....##....########

  describe 'POST #create' do
    subject(:request) do
      post api_v1_work_assets_path(work_id), headers:, params:
    end

    let_it_be(:user) { create(:user, :confirmed) }
    let_it_be(:work) { create(:work) }
    let_it_be(:asset) { create(:asset) }
    let(:work_id) { work.id }

    context 'when user does not signed-in' do
      let_it_be(:headers) { {} }
      let_it_be(:params) do
        {
          asset: {
            id: asset.id
          }
        }
      end

      it_behaves_like 'unauthorized' do
        before { request }
      end

      it 'does not create a new work asset' do
        expect { request }.not_to(change(WorkAsset, :count))
      end

      it 'does not link the work to the asset' do
        expect { request }.not_to(change(work.assets, :count))
      end
    end

    context 'when work is not found' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          asset: {
            id: asset.id
          }
        }
      end
      let(:work_id) { 'invalid-work-id' }

      it_behaves_like 'not_found' do
        before { request }
      end

      it 'does not create a new work asset' do
        expect { request }.not_to(change(WorkAsset, :count))
      end

      it 'does not link the work to the asset' do
        expect { request }.not_to(change(work.assets, :count))
      end
    end

    context 'when lack of id params' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          asset: {
            hoge: 'fuga'
          }
        }
      end

      it_behaves_like 'bad_request' do
        before { request }
      end

      it 'does not create a new work asset' do
        expect { request }.not_to(change(WorkAsset, :count))
      end

      it 'does not link the work to the asset' do
        expect { request }.not_to(change(work.assets, :count))
      end
    end

    context 'when id is nil' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          asset: {
            id: nil
          }
        }
      end

      it_behaves_like 'not_found' do
        before { request }
      end

      it 'does not create a new work asset' do
        expect { request }.not_to(change(WorkAsset, :count))
      end

      it 'does not link the work to the asset' do
        expect { request }.not_to(change(work.assets, :count))
      end
    end

    context 'when asset is not found' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          asset: {
            id: 'invalid-asset-id'
          }
        }
      end

      it_behaves_like 'not_found' do
        before { request }
      end

      it 'does not create a new work asset' do
        expect { request }.not_to(change(WorkAsset, :count))
      end

      it 'does not link the work to the asset' do
        expect { request }.not_to(change(work.assets, :count))
      end
    end

    context 'when the work already have the asset' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          asset: {
            id: asset.id
          }
        }
      end

      before_all do
        create(:work_asset, work:, asset:)
      end

      it_behaves_like 'unprocessable_entity' do
        before { request }
      end

      it 'does not create a new work asset' do
        expect { request }.not_to(change(WorkAsset, :count))
      end

      it 'does not link the work to the asset' do
        expect { request }.not_to(change(work.assets, :count))
      end
    end

    context 'when params is valid' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          asset: {
            id: asset.id
          }
        }
      end

      it_behaves_like 'no_content' do
        before { request }
      end

      it 'creates a new work asset' do
        expect { request }.to change(WorkAsset, :count).by(1)
      end

      it 'links the work to the asset' do
        expect { request }.to change(work.assets, :count).by(1)
      end

      it 'links the asset by the user' do
        request

        expect(work.work_assets.first.created_user).to eq(user)
      end
    end
  end
end
