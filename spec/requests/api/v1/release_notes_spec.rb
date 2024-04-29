require 'rails_helper'

RSpec.describe 'Api::V1::ReleaseNotes' do
  #   ..######...########.########......##.##...####.##....##.########..########.##.....##
  #   .##....##..##..........##.........##.##....##..###...##.##.....##.##........##...##.
  #   .##........##..........##.......#########..##..####..##.##.....##.##.........##.##..
  #   .##...####.######......##.........##.##....##..##.##.##.##.....##.######......###...
  #   .##....##..##..........##.......#########..##..##..####.##.....##.##.........##.##..
  #   .##....##..##..........##.........##.##....##..##...###.##.....##.##........##...##.
  #   ..######...########....##.........##.##...####.##....##.########..########.##.....##

  describe 'GET #index' do
    subject(:request) do
      get api_v1_release_notes_path(page:)
    end

    context 'with no query when no release note exists' do
      let_it_be(:page) { nil }

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns 0 release_notes' do
        request
        body = response.parsed_body

        expect(body['data'].size).to eq(0)
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

    context 'with page 1 when no release note exists' do
      let_it_be(:page) { 1 }

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns 0 release_notes' do
        request
        body = response.parsed_body

        expect(body['data'].size).to eq(0)
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

    context 'with no query when 24 release notes exist' do
      let_it_be(:page) { nil }
      let_it_be(:release_notes) { create_list(:release_note, 24) }

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns 24 release_notes' do
        request
        body = response.parsed_body

        expect(body['data'].size).to eq(24)
      end

      it 'release_notes are ordered by descending version' do
        request
        body = response.parsed_body

        expect(body['data'].pluck('version')).to eq(release_notes.map(&:version).sort.reverse)
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

    context 'with page 1 when 24 release notes exist' do
      let_it_be(:page) { 1 }
      let_it_be(:release_notes) { create_list(:release_note, 24) }

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns 24 release_notes' do
        request
        body = response.parsed_body

        expect(body['data'].size).to eq(24)
      end

      it 'release_notes are ordered by descending version' do
        request
        body = response.parsed_body

        expect(body['data'].pluck('version')).to eq(release_notes.map(&:version).sort.reverse)
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

    context 'with page 2 when 24 release notes exist' do
      let_it_be(:page) { 2 }
      let_it_be(:release_notes) { create_list(:release_note, 24) }

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns 0 release_notes' do
        request
        body = response.parsed_body

        expect(body['data'].size).to eq(0)
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

    context 'with no query when 25 release notes exist' do
      let_it_be(:page) { nil }
      let_it_be(:release_notes) { create_list(:release_note, 25) }

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns 24 release_notes' do
        request
        body = response.parsed_body

        expect(body['data'].size).to eq(24)
      end

      it 'release_notes are ordered by descending version' do
        request
        body = response.parsed_body

        expect(body['data'].pluck('version')).to eq(release_notes.map(&:version).sort.last(24).reverse)
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

    context 'with page 1 when 25 release notes exist' do
      let_it_be(:page) { 1 }
      let_it_be(:release_notes) { create_list(:release_note, 25) }

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns 24 release_notes' do
        request
        body = response.parsed_body

        expect(body['data'].size).to eq(24)
      end

      it 'release_notes are ordered by descending version' do
        request
        body = response.parsed_body

        expect(body['data'].pluck('version')).to eq(release_notes.map(&:version).sort.last(24).reverse)
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

    context 'with page 2 when 25 release notes exist' do
      let_it_be(:page) { 2 }
      let_it_be(:release_notes) { create_list(:release_note, 25) }

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns 1 release_note' do
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

    context 'with page 3 when 25 release notes exist' do
      let_it_be(:page) { 3 }
      let_it_be(:release_notes) { create_list(:release_note, 25) }

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns 0 release_notes' do
        request
        body = response.parsed_body

        expect(body['data'].size).to eq(0)
      end

      it 'returns correct meta pagination' do
        request
        body = response.parsed_body

        expect(body['meta']).to eq(
          'currentPage' => 3,
          'hasNext' => false,
          'hasPrevious' => false,
          'totalCount' => 25,
          'totalPages' => 2
        )
      end
    end

    context 'with page as string' do
      let_it_be(:page) { 'page' }

      it_behaves_like 'bad request' do
        before { request }
      end
    end
  end
end
