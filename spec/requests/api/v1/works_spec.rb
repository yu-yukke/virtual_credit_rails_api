require 'rails_helper'

RSpec.describe 'Api::V1::Works' do
  #   .########...#######...######..########......##.##....######..########..########....###....########.########
  #   .##.....##.##.....##.##....##....##.........##.##...##....##.##.....##.##.........##.##......##....##......
  #   .##.....##.##.....##.##..........##.......#########.##.......##.....##.##........##...##.....##....##......
  #   .########..##.....##..######.....##.........##.##...##.......########..######...##.....##....##....######..
  #   .##........##.....##.......##....##.......#########.##.......##...##...##.......#########....##....##......
  #   .##........##.....##.##....##....##.........##.##...##....##.##....##..##.......##.....##....##....##......
  #   .##.........#######...######.....##.........##.##....######..##.....##.########.##.....##....##....########

  describe 'POST #create' do
    subject(:request) do
      post api_v1_works_path, headers:, params:
    end

    let_it_be(:user) { create(:user, :confirmed) }

    context 'when user does not signed-in' do
      let_it_be(:headers) { {} }
      let_it_be(:params) do
        {
          work: {
            title: 'test title',
            description: 'test description',
            cover_image: fixture_file_upload(
              Rails.root.join('spec/fixtures/bg_sample_1.jpeg'), 'image/jpeg'
            )
          }
        }
      end

      it_behaves_like 'unauthorized' do
        before { request }
      end

      it 'does not create a new work' do
        expect { request }.not_to(change(Work, :count))
      end
    end

    context 'when user signed-in and params is valid' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          work: {
            title: 'test title',
            description: 'test description',
            cover_image: fixture_file_upload(
              Rails.root.join('spec/fixtures/bg_sample_1.jpeg'), 'image/jpeg'
            )
          }
        }
      end

      it_behaves_like 'created' do
        before { request }
      end

      it 'creates a new work' do
        expect { request }.to(change(Work, :count).by(1))
      end
    end

    context 'when lack of title params' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          work: {
            description: 'test description',
            cover_image: fixture_file_upload(
              Rails.root.join('spec/fixtures/bg_sample_1.jpeg'), 'image/jpeg'
            )
          }
        }
      end

      it_behaves_like 'bad_request' do
        before { request }
      end

      it 'does not create a new work' do
        expect { request }.not_to(change(Work, :count))
      end
    end

    context 'when title is nil' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          work: {
            title: nil,
            description: 'test description',
            cover_image: fixture_file_upload(
              Rails.root.join('spec/fixtures/bg_sample_1.jpeg'), 'image/jpeg'
            )
          }
        }
      end

      it_behaves_like 'unprocessable_entity' do
        before { request }
      end

      it 'does not create a new work' do
        expect { request }.not_to(change(Work, :count))
      end
    end

    context 'when title is blank' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          work: {
            title: '',
            description: 'test description',
            cover_image: fixture_file_upload(
              Rails.root.join('spec/fixtures/bg_sample_1.jpeg'), 'image/jpeg'
            )
          }
        }
      end

      it_behaves_like 'unprocessable_entity' do
        before { request }
      end

      it 'does not create a new work' do
        expect { request }.not_to(change(Work, :count))
      end
    end

    context 'when lack of description params' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          work: {
            title: 'test title',
            cover_image: fixture_file_upload(
              Rails.root.join('spec/fixtures/bg_sample_1.jpeg'), 'image/jpeg'
            )
          }
        }
      end

      it_behaves_like 'bad_request' do
        before { request }
      end

      it 'does not create a new work' do
        expect { request }.not_to(change(Work, :count))
      end
    end

    context 'when description is nil' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          work: {
            title: 'test title',
            description: nil,
            cover_image: fixture_file_upload(
              Rails.root.join('spec/fixtures/bg_sample_1.jpeg'), 'image/jpeg'
            )
          }
        }
      end

      it_behaves_like 'unprocessable_entity' do
        before { request }
      end

      it 'does not create a new work' do
        expect { request }.not_to(change(Work, :count))
      end
    end

    context 'when description is blank' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          work: {
            title: 'test title',
            description: '',
            cover_image: fixture_file_upload(
              Rails.root.join('spec/fixtures/bg_sample_1.jpeg'), 'image/jpeg'
            )
          }
        }
      end

      it_behaves_like 'unprocessable_entity' do
        before { request }
      end

      it 'does not create a new work' do
        expect { request }.not_to(change(Work, :count))
      end
    end

    context 'when lack of cover_image params' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          work: {
            title: 'test title',
            description: 'test description'
          }
        }
      end

      it_behaves_like 'bad_request' do
        before { request }
      end

      it 'does not create a new user_skill' do
        expect { request }.not_to(change(Work, :count))
      end
    end

    context 'when cover_image is nil' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          work: {
            title: 'test title',
            description: 'test description',
            cover_image: nil
          }
        }
      end

      it_behaves_like 'unprocessable_entity' do
        before { request }
      end

      it 'does not create a new work' do
        expect { request }.not_to(change(Work, :count))
      end
    end

    context 'when cover_image is blank' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          work: {
            title: 'test title',
            description: 'test description',
            cover_image: ''
          }
        }
      end

      it_behaves_like 'unprocessable_entity' do
        before { request }
      end

      it 'does not create a new work' do
        expect { request }.not_to(change(Work, :count))
      end
    end
  end
end
