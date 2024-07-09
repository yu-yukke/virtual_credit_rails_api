require 'rails_helper'

RSpec.describe 'Api::V1::Works::Likes' do
  #   .########...#######...######..########......##.##....######..########..########....###....########.########
  #   .##.....##.##.....##.##....##....##.........##.##...##....##.##.....##.##.........##.##......##....##......
  #   .##.....##.##.....##.##..........##.......#########.##.......##.....##.##........##...##.....##....##......
  #   .########..##.....##..######.....##.........##.##...##.......########..######...##.....##....##....######..
  #   .##........##.....##.......##....##.......#########.##.......##...##...##.......#########....##....##......
  #   .##........##.....##.##....##....##.........##.##...##....##.##....##..##.......##.....##....##....##......
  #   .##.........#######...######.....##.........##.##....######..##.....##.########.##.....##....##....########

  describe 'POST #create' do
    subject(:request) do
      post api_v1_work_likes_path(work_id), headers:
    end

    let_it_be(:user) { create(:user, :confirmed) }
    let_it_be(:work) { create(:work) }
    let(:work_id) { work.id }

    context 'when user does not signed-in' do
      let_it_be(:headers) { {} }

      it_behaves_like 'unauthorized' do
        before { request }
      end

      it 'does not create a new like' do
        expect { request }.not_to(change(Like, :count))
      end
    end

    context 'when work is not found' do
      let_it_be(:headers) { sign_in(user) }
      let(:work_id) { 'invalid-work-id' }

      it_behaves_like 'not_found' do
        before { request }
      end

      it 'does not create a new like' do
        expect { request }.not_to(change(Like, :count))
      end
    end

    context 'when the work is already liked by the user' do
      let_it_be(:headers) { sign_in(user) }

      before_all do
        create(:like, work:, user:)
      end

      it_behaves_like 'unprocessable_entity' do
        before { request }
      end

      it 'does not create a new like' do
        expect { request }.not_to(change(Like, :count))
      end
    end

    context 'when the work is not liked by the user' do
      let_it_be(:headers) { sign_in(user) }

      it_behaves_like 'no_content' do
        before { request }
      end

      it 'creates new like' do
        expect { request }.to change(Like, :count).by(1)
      end

      it 'likes the work' do
        expect { request }.to change(work.likes, :count).by(1)
      end

      it 'likes the work by the user' do
        request

        expect(work.likes.first.user).to eq(user)
      end
    end
  end
end
