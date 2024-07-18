require 'rails_helper'

RSpec.describe 'Api::V1::Works' do
  #   ..######...########.########......##.##...####.##....##.########..########.##.....##
  #   .##....##..##..........##.........##.##....##..###...##.##.....##.##........##...##.
  #   .##........##..........##.......#########..##..####..##.##.....##.##.........##.##..
  #   .##...####.######......##.........##.##....##..##.##.##.##.....##.######......###...
  #   .##....##..##..........##.......#########..##..##..####.##.....##.##.........##.##..
  #   .##....##..##..........##.........##.##....##..##...###.##.....##.##........##...##.
  #   ..######...########....##.........##.##...####.##....##.########..########.##.....##

  describe 'GET #index' do
    subject(:request) do
      get api_v1_works_path(page:), headers:
    end

    let_it_be(:user) { create(:user, :confirmed) }
    let(:page) { nil }

    context 'when user does not signed-in and no public works exists' do
      let_it_be(:headers) { {} }

      before_all do
        create_list(:work, 3, :has_images)
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns no works' do
        request
        body = response.parsed_body

        expect(body['data']).to eq([])
      end

      it 'returns correct meta pagination' do
        request
        body = response.parsed_body

        expect(body['meta']).to eq(
          'currentPage' => 1,
          'hasNext' => false,
          'hasPrevious' => false,
          'totalCount' => 0,
          'totalPages' => 0
        )
      end
    end

    context 'when user does not signed-in and 24 public works exists and specify page as nil' do
      let_it_be(:headers) { {} }

      before_all do
        create_list(:work, 24, :published, :has_images)
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns 24 public works' do
        request
        body = response.parsed_body

        expect(body['data'].size).to eq(24)
      end

      it 'returns correct meta pagination' do
        request
        body = response.parsed_body

        expect(body['meta']).to eq(
          'currentPage' => 1,
          'hasNext' => false,
          'hasPrevious' => false,
          'totalCount' => 24,
          'totalPages' => 1
        )
      end
    end

    context 'when user does not signed-in and 24 public works exists and specify page as 1' do
      let_it_be(:headers) { {} }
      let(:page) { 1 }

      before_all do
        create_list(:work, 24, :published, :has_images)
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns 24 public works' do
        request
        body = response.parsed_body

        expect(body['data'].size).to eq(24)
      end

      it 'returns correct meta pagination' do
        request
        body = response.parsed_body

        expect(body['meta']).to eq(
          'currentPage' => 1,
          'hasNext' => false,
          'hasPrevious' => false,
          'totalCount' => 24,
          'totalPages' => 1
        )
      end
    end

    context 'when user does not signed-in and 24 public works exists and specify page as 2' do
      let_it_be(:headers) { {} }
      let(:page) { 2 }

      before_all do
        create_list(:work, 24, :published, :has_images)
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns no works' do
        request
        body = response.parsed_body

        expect(body['data']).to eq([])
      end

      it 'returns correct meta pagination' do
        request
        body = response.parsed_body

        expect(body['meta']).to eq(
          'currentPage' => 2,
          'hasNext' => false,
          'hasPrevious' => false,
          'totalCount' => 24,
          'totalPages' => 1
        )
      end
    end

    context 'when user does not signed-in and 25 public works exists and specify page as nil' do
      let_it_be(:headers) { {} }

      before_all do
        create_list(:work, 25, :published, :has_images)
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns 24 public works' do
        request
        body = response.parsed_body

        expect(body['data'].size).to eq(24)
      end

      it 'returns correct meta pagination' do
        request
        body = response.parsed_body

        expect(body['meta']).to eq(
          'currentPage' => 1,
          'hasNext' => true,
          'hasPrevious' => false,
          'totalCount' => 25,
          'totalPages' => 2
        )
      end
    end

    context 'when user does not signed-in and 25 public works exists and specify page as 1' do
      let_it_be(:headers) { {} }
      let(:page) { 1 }

      before_all do
        create_list(:work, 25, :published, :has_images)
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns 24 public works' do
        request
        body = response.parsed_body

        expect(body['data'].size).to eq(24)
      end

      it 'returns correct meta pagination' do
        request
        body = response.parsed_body

        expect(body['meta']).to eq(
          'currentPage' => 1,
          'hasNext' => true,
          'hasPrevious' => false,
          'totalCount' => 25,
          'totalPages' => 2
        )
      end
    end

    context 'when user does not signed-in and 25 public works exists and specify page as 2' do
      let_it_be(:headers) { {} }
      let(:page) { 2 }

      before_all do
        create_list(:work, 25, :published, :has_images)
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns 1 work' do
        request
        body = response.parsed_body

        expect(body['data'].size).to eq(1)
      end

      it 'returns correct meta pagination' do
        request
        body = response.parsed_body

        expect(body['meta']).to eq(
          'currentPage' => 2,
          'hasNext' => false,
          'hasPrevious' => true,
          'totalCount' => 25,
          'totalPages' => 2
        )
      end
    end

    context 'when user signed-in and no public works exists' do
      let_it_be(:headers) { sign_in(user) }

      before_all do
        create_list(:work, 3, :has_images)
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns no works' do
        request
        body = response.parsed_body

        expect(body['data']).to eq([])
      end

      it 'returns correct meta pagination' do
        request
        body = response.parsed_body

        expect(body['meta']).to eq(
          'currentPage' => 1,
          'hasNext' => false,
          'hasPrevious' => false,
          'totalCount' => 0,
          'totalPages' => 0
        )
      end
    end

    context 'when user signed-in and 24 public works exists and specify page as nil' do
      let_it_be(:headers) { sign_in(user) }

      before_all do
        create_list(:work, 24, :published, :has_images)
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns 24 public works' do
        request
        body = response.parsed_body

        expect(body['data'].size).to eq(24)
      end

      it 'returns correct meta pagination' do
        request
        body = response.parsed_body

        expect(body['meta']).to eq(
          'currentPage' => 1,
          'hasNext' => false,
          'hasPrevious' => false,
          'totalCount' => 24,
          'totalPages' => 1
        )
      end
    end

    context 'when user signed-in and 24 public works exists and specify page as 1' do
      let_it_be(:headers) { sign_in(user) }
      let(:page) { 1 }

      before_all do
        create_list(:work, 24, :published, :has_images)
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns 24 public works' do
        request
        body = response.parsed_body

        expect(body['data'].size).to eq(24)
      end

      it 'returns correct meta pagination' do
        request
        body = response.parsed_body

        expect(body['meta']).to eq(
          'currentPage' => 1,
          'hasNext' => false,
          'hasPrevious' => false,
          'totalCount' => 24,
          'totalPages' => 1
        )
      end
    end

    context 'when user signed-in and 24 public works exists and specify page as 2' do
      let_it_be(:headers) { sign_in(user) }
      let(:page) { 2 }

      before_all do
        create_list(:work, 24, :published, :has_images)
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns no works' do
        request
        body = response.parsed_body

        expect(body['data']).to eq([])
      end

      it 'returns correct meta pagination' do
        request
        body = response.parsed_body

        expect(body['meta']).to eq(
          'currentPage' => 2,
          'hasNext' => false,
          'hasPrevious' => false,
          'totalCount' => 24,
          'totalPages' => 1
        )
      end
    end

    context 'when user signed-in and 25 public works exists and specify page as nil' do
      let_it_be(:headers) { sign_in(user) }

      before_all do
        create_list(:work, 25, :published, :has_images)
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns 24 public works' do
        request
        body = response.parsed_body

        expect(body['data'].size).to eq(24)
      end

      it 'returns correct meta pagination' do
        request
        body = response.parsed_body

        expect(body['meta']).to eq(
          'currentPage' => 1,
          'hasNext' => true,
          'hasPrevious' => false,
          'totalCount' => 25,
          'totalPages' => 2
        )
      end
    end

    context 'when user signed-in and 25 public works exists and specify page as 1' do
      let_it_be(:headers) { sign_in(user) }
      let(:page) { 1 }

      before_all do
        create_list(:work, 25, :published, :has_images)
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns 24 public works' do
        request
        body = response.parsed_body

        expect(body['data'].size).to eq(24)
      end

      it 'returns correct meta pagination' do
        request
        body = response.parsed_body

        expect(body['meta']).to eq(
          'currentPage' => 1,
          'hasNext' => true,
          'hasPrevious' => false,
          'totalCount' => 25,
          'totalPages' => 2
        )
      end
    end

    context 'when user signed-in and 25 public works exists and specify page as 2' do
      let_it_be(:headers) { sign_in(user) }
      let(:page) { 2 }

      before_all do
        create_list(:work, 25, :published, :has_images)
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns 1 work' do
        request
        body = response.parsed_body

        expect(body['data'].size).to eq(1)
      end

      it 'returns correct meta pagination' do
        request
        body = response.parsed_body

        expect(body['meta']).to eq(
          'currentPage' => 2,
          'hasNext' => false,
          'hasPrevious' => true,
          'totalCount' => 25,
          'totalPages' => 2
        )
      end
    end
  end

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
