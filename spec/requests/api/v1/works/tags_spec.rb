require 'rails_helper'

RSpec.describe 'Api::V1::Works::Tags' do
  #   .########...#######...######..########......##.##....######..########..########....###....########.########
  #   .##.....##.##.....##.##....##....##.........##.##...##....##.##.....##.##.........##.##......##....##......
  #   .##.....##.##.....##.##..........##.......#########.##.......##.....##.##........##...##.....##....##......
  #   .########..##.....##..######.....##.........##.##...##.......########..######...##.....##....##....######..
  #   .##........##.....##.......##....##.......#########.##.......##...##...##.......#########....##....##......
  #   .##........##.....##.##....##....##.........##.##...##....##.##....##..##.......##.....##....##....##......
  #   .##.........#######...######.....##.........##.##....######..##.....##.########.##.....##....##....########

  describe 'POST #create' do
    subject(:request) do
      post api_v1_work_tags_path(work_id), headers:, params:
    end

    let_it_be(:user) { create(:user, :confirmed) }
    let_it_be(:work) { create(:work) }
    let_it_be(:tag) { create(:tag) }
    let(:work_id) { work.id }

    context 'when user does not signed-in' do
      let_it_be(:headers) { {} }
      let_it_be(:params) do
        {
          tag: {
            id: tag.id
          }
        }
      end

      it_behaves_like 'unauthorized' do
        before { request }
      end

      it 'does not create a new work tag' do
        expect { request }.not_to(change(WorkTag, :count))
      end

      it 'does not tag the work to the tag' do
        expect { request }.not_to(change(work.tags, :count))
      end
    end

    context 'when work is not found' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          tag: {
            id: tag.id
          }
        }
      end
      let(:work_id) { 'invalid-work-id' }

      it_behaves_like 'not_found' do
        before { request }
      end

      it 'does not create a new work tag' do
        expect { request }.not_to(change(WorkTag, :count))
      end

      it 'does not tag the work to the tag' do
        expect { request }.not_to(change(work.tags, :count))
      end
    end

    context 'when lack of id params' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          tag: {
            hoge: 'fuga'
          }
        }
      end

      it_behaves_like 'bad_request' do
        before { request }
      end

      it 'does not create a new work tag' do
        expect { request }.not_to(change(WorkTag, :count))
      end

      it 'does not tag the work to the tag' do
        expect { request }.not_to(change(work.tags, :count))
      end
    end

    context 'when id is nil' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          tag: {
            id: nil
          }
        }
      end

      it_behaves_like 'not_found' do
        before { request }
      end

      it 'does not create a new work tag' do
        expect { request }.not_to(change(WorkTag, :count))
      end

      it 'does not tag the work to the tag' do
        expect { request }.not_to(change(work.tags, :count))
      end
    end

    context 'when tag is not found' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          tag: {
            id: 'invalid-tag-id'
          }
        }
      end

      it_behaves_like 'not_found' do
        before { request }
      end

      it 'does not create a new work tag' do
        expect { request }.not_to(change(WorkTag, :count))
      end

      it 'does not tag the work to the tag' do
        expect { request }.not_to(change(work.tags, :count))
      end
    end

    context 'when the work is already tagged to the tag' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          tag: {
            id: tag.id
          }
        }
      end

      before_all do
        create(:work_tag, work:, tag:)
      end

      it_behaves_like 'unprocessable_entity' do
        before { request }
      end

      it 'does not create a new work tag' do
        expect { request }.not_to(change(WorkTag, :count))
      end

      it 'does not tag the work to the tag' do
        expect { request }.not_to(change(work.tags, :count))
      end
    end

    context 'when params is valid' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          tag: {
            id: tag.id
          }
        }
      end

      it_behaves_like 'no_content' do
        before { request }
      end

      it 'creates a new work tag' do
        expect { request }.to change(WorkTag, :count).by(1)
      end

      it 'tags the work to the tag' do
        expect { request }.to change(work.tags, :count).by(1)
      end

      it 'tags the tag by the user' do
        request

        expect(work.work_tags.first.created_user).to eq(user)
      end
    end
  end
end
