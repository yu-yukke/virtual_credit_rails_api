require 'rails_helper'

RSpec.describe 'Api::V1::Works::WorkImages' do
  #   .########...#######...######..########......##.##....######..########..########....###....########.########
  #   .##.....##.##.....##.##....##....##.........##.##...##....##.##.....##.##.........##.##......##....##......
  #   .##.....##.##.....##.##..........##.......#########.##.......##.....##.##........##...##.....##....##......
  #   .########..##.....##..######.....##.........##.##...##.......########..######...##.....##....##....######..
  #   .##........##.....##.......##....##.......#########.##.......##...##...##.......#########....##....##......
  #   .##........##.....##.##....##....##.........##.##...##....##.##....##..##.......##.....##....##....##......
  #   .##.........#######...######.....##.........##.##....######..##.....##.########.##.....##....##....########

  describe 'POST #create' do
    subject(:request) do
      post api_v1_work_work_images_path(work_id), headers:, params:
    end

    let_it_be(:user) { create(:user, :confirmed) }
    let_it_be(:work) { create(:work, author: user) }
    let(:work_id) { work.id }

    context 'when user does not signed-in' do
      let_it_be(:headers) { {} }
      let_it_be(:params) do
        {
          image: {
            content: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/work_image_sample_1.png'), 'image/png')
          }
        }
      end

      it_behaves_like 'unauthorized' do
        before { request }
      end

      it 'does not create a new work image' do
        expect { request }.not_to(change(work.images, :count))
      end
    end

    context 'when work is not found' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          image: {
            content: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/work_image_sample_1.png'), 'image/png')
          }
        }
      end
      let(:work_id) { 'invalid-work-id' }

      it_behaves_like 'not_found' do
        before { request }
      end

      it 'does not create a new work image' do
        expect { request }.not_to(change(work.images, :count))
      end
    end

    context 'when lack of content params' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          image: {
            hoge: 'fuga'
          }
        }
      end

      it_behaves_like 'bad_request' do
        before { request }
      end

      it 'does not create a new work image' do
        expect { request }.not_to(change(work.images, :count))
      end
    end

    context 'when content is nil' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          image: {
            content: nil
          }
        }
      end

      it_behaves_like 'unprocessable_entity' do
        before { request }
      end

      it 'does not create a new work image' do
        expect { request }.not_to(change(work.images, :count))
      end
    end

    context 'when content is blank' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          image: {
            content: ''
          }
        }
      end

      it_behaves_like 'unprocessable_entity' do
        before { request }
      end

      it 'does not create a new work image' do
        expect { request }.not_to(change(work.images, :count))
      end
    end

    context 'when params has image content' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          image: {
            content: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/work_image_sample_1.png'), 'image/png')
          }
        }
      end

      it_behaves_like 'created' do
        before { request }
      end

      it 'creates a new work image' do
        expect { request }.to(change(work.images, :count).by(1))
      end
    end
  end
end
