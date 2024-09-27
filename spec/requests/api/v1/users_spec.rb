require 'rails_helper'

RSpec.describe 'Api::V1::Users' do
  #   ..######...########.########......##.##...####.##....##.########..########.##.....##
  #   .##....##..##..........##.........##.##....##..###...##.##.....##.##........##...##.
  #   .##........##..........##.......#########..##..####..##.##.....##.##.........##.##..
  #   .##...####.######......##.........##.##....##..##.##.##.##.....##.######......###...
  #   .##....##..##..........##.......#########..##..##..####.##.....##.##.........##.##..
  #   .##....##..##..........##.........##.##....##..##...###.##.....##.##........##...##.
  #   ..######...########....##.........##.##...####.##....##.########..########.##.....##

  describe 'GET #index' do
    subject(:request) do
      get api_v1_users_path(page:), headers:
    end

    let_it_be(:user) { create(:user, :confirmed) }
    let(:page) { nil }

    context 'when user does not signed-in and no public users exists' do
      let_it_be(:headers) { {} }

      before_all do
        create_list(:user, 3, :activated, :with_works, :with_copyrights)
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns no users' do
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

    context 'when user does not signed-in and 24 public users exists and specify page as nil' do
      let_it_be(:headers) { {} }

      before_all do
        create_list(:user, 24, :published, :with_works, :with_copyrights)
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns 24 public users' do
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

    context 'when user does not signed-in and 24 public users exists and specify page as 1' do
      let_it_be(:headers) { {} }
      let(:page) { 1 }

      before_all do
        create_list(:user, 24, :published, :with_works, :with_copyrights)
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns 24 public users' do
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

    context 'when user does not signed-in and 24 public users exists and specify page as 2' do
      let_it_be(:headers) { {} }
      let(:page) { 2 }

      before_all do
        create_list(:user, 24, :published, :with_works, :with_copyrights)
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns no users' do
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

    context 'when user does not signed-in and 25 public users exists and specify page as nil' do
      let_it_be(:headers) { {} }

      before_all do
        create_list(:user, 25, :published, :with_works, :with_copyrights)
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns 24 public users' do
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

    context 'when user does not signed-in and 25 public users exists and specify page as 1' do
      let_it_be(:headers) { {} }
      let(:page) { 1 }

      before_all do
        create_list(:user, 25, :published, :with_works, :with_copyrights)
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns 24 public users' do
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

    context 'when user does not signed-in and 25 public users exists and specify page as 2' do
      let_it_be(:headers) { {} }
      let(:page) { 2 }

      before_all do
        create_list(:user, 25, :published, :with_works, :with_copyrights)
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns 1 user' do
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

    context 'when user signed-in and no public users exists' do
      let_it_be(:headers) { sign_in(user) }

      before_all do
        create_list(:user, 3, :activated, :with_works, :with_copyrights)
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns no users' do
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

    context 'when user signed-in and 24 public users exists and specify page as nil' do
      let_it_be(:headers) { sign_in(user) }

      before_all do
        create_list(:user, 24, :published, :with_works, :with_copyrights)
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns 24 public users' do
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

    context 'when user signed-in and 24 public users exists and specify page as 1' do
      let_it_be(:headers) { sign_in(user) }
      let(:page) { 1 }

      before_all do
        create_list(:user, 24, :published, :with_works, :with_copyrights)
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns 24 public users' do
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

    context 'when user signed-in and 24 public users exists and specify page as 2' do
      let_it_be(:headers) { sign_in(user) }
      let(:page) { 2 }

      before_all do
        create_list(:user, 24, :published, :with_works, :with_copyrights)
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns no users' do
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

    context 'when user signed-in and 25 public users exists and specify page as nil' do
      let_it_be(:headers) { sign_in(user) }

      before_all do
        create_list(:user, 25, :published, :with_works, :with_copyrights)
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns 24 public users' do
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

    context 'when user signed-in and 25 public users exists and specify page as 1' do
      let_it_be(:headers) { sign_in(user) }
      let(:page) { 1 }

      before_all do
        create_list(:user, 25, :published, :with_works, :with_copyrights)
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns 24 public users' do
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

    context 'when user signed-in and 25 public users exists and specify page as 2' do
      let_it_be(:headers) { sign_in(user) }
      let(:page) { 2 }

      before_all do
        create_list(:user, 25, :published, :with_works, :with_copyrights)
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns 1 user' do
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

    context 'when user has unpublised works' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:published_user) { create(:user, :published, :with_works, :with_copyrights) }
      let_it_be(:unpublished_work) { create(:work, :unpublished, author: published_user) }
      let(:page) { nil }

      it 'returns the user' do
        request
        body = response.parsed_body

        expect(body['data'].size).to eq(1)
      end

      it 'returns the user not including unpublished works' do
        request
        body = response.parsed_body

        expect(body['data'][0]['myWorks'].pluck('id')).not_to include(unpublished_work.id)
      end

      it 'returns correct meta pagination' do
        request
        body = response.parsed_body

        expect(body['meta']).to eq(
          'currentPage' => 1,
          'hasNext' => false,
          'hasPrevious' => false,
          'totalCount' => 1,
          'totalPages' => 1
        )
      end
    end

    context 'when published users and unpublished users exist' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:unpublished_user) { create(:user, :activated, :with_works, :with_copyrights) }
      let(:page) { nil }

      before_all do
        create_list(:user, 12, :published, :with_works, :with_copyrights)
      end

      it 'returns the user' do
        request
        body = response.parsed_body

        expect(body['data'].size).to eq(12)
      end

      it 'returns the users not including unpublished user' do
        request
        body = response.parsed_body

        expect(body['data'].pluck('id')).not_to include(unpublished_user.id)
      end

      it 'returns correct meta pagination' do
        request
        body = response.parsed_body

        expect(body['meta']).to eq(
          'currentPage' => 1,
          'hasNext' => false,
          'hasPrevious' => false,
          'totalCount' => 12,
          'totalPages' => 1
        )
      end
    end
  end

  #   ..######...########.########......##.##....######..##.....##..#######..##......##
  #   .##....##..##..........##.........##.##...##....##.##.....##.##.....##.##..##..##
  #   .##........##..........##.......#########.##.......##.....##.##.....##.##..##..##
  #   .##...####.######......##.........##.##....######..#########.##.....##.##..##..##
  #   .##....##..##..........##.......#########.......##.##.....##.##.....##.##..##..##
  #   .##....##..##..........##.........##.##...##....##.##.....##.##.....##.##..##..##
  #   ..######...########....##.........##.##....######..##.....##..#######...###..###.

  describe 'GET #show' do
    subject(:request) do
      get api_v1_user_path(slug:), headers:
    end

    let_it_be(:users_me) { create(:user, :confirmed) }

    context 'when user does not signed-in and user does not exist' do
      let(:slug) { 'not-exist-user' }

      it_behaves_like 'not_found' do
        before { request }
      end
    end

    context 'with activated user when user does not signed-in' do
      let_it_be(:headers) { {} }
      let_it_be(:user) { create(:user, :activated, :with_works, :with_copyrights) }
      let(:slug) { user.slug }

      it_behaves_like 'not_found' do
        before { request }
      end
    end

    context 'with published user when user does not signed-in' do
      let_it_be(:headers) { {} }
      let_it_be(:user) { create(:user, :published, :with_works, :with_copyrights) }
      let(:slug) { user.slug }

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns the user' do
        request
        body = response.parsed_body

        expect(body['data']['id']).to eq(user.id.to_s)
      end
    end

    context 'when user signed-in and user does not exist' do
      let_it_be(:headers) { sign_in(users_me) }
      let(:slug) { 'not-exist-user' }

      it_behaves_like 'not_found' do
        before { request }
      end
    end

    context 'with activated user when user signed-in' do
      let_it_be(:headers) { sign_in(users_me) }
      let_it_be(:user) { create(:user, :activated, :with_works, :with_copyrights) }
      let(:slug) { user.slug }

      it_behaves_like 'not_found' do
        before { request }
      end
    end

    context 'with published user when user signed-in' do
      let_it_be(:headers) { sign_in(users_me) }
      let_it_be(:user) { create(:user, :published, :with_works, :with_copyrights) }
      let(:slug) { user.slug }

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns the user' do
        request
        body = response.parsed_body

        expect(body['data']['id']).to eq(user.id.to_s)
      end
    end
  end
end
