require 'rails_helper'

RSpec.describe 'Api::V1::Works::Copyrights::Users' do
  #   .########...#######...######..########......##.##....######..########..########....###....########.########
  #   .##.....##.##.....##.##....##....##.........##.##...##....##.##.....##.##.........##.##......##....##......
  #   .##.....##.##.....##.##..........##.......#########.##.......##.....##.##........##...##.....##....##......
  #   .########..##.....##..######.....##.........##.##...##.......########..######...##.....##....##....######..
  #   .##........##.....##.......##....##.......#########.##.......##...##...##.......#########....##....##......
  #   .##........##.....##.##....##....##.........##.##...##....##.##....##..##.......##.....##....##....##......
  #   .##.........#######...######.....##.........##.##....######..##.....##.########.##.....##....##....########

  describe 'POST #create' do
    subject(:request) do
      post api_v1_work_copyright_users_path(work_id, copyright_id), headers:, params:
    end

    let_it_be(:current_user) { create(:user, :confirmed) }
    let_it_be(:work) { create(:work) }
    let_it_be(:copyright) { create(:copyright, work:) }
    let(:work_id) { work.id }
    let(:copyright_id) { copyright.id }

    context 'when user does not signed-in' do
      let_it_be(:headers) { {} }
      let_it_be(:user) { create(:user, :published) }
      let_it_be(:params) do
        {
          user: {
            id: user.id
          }
        }
      end

      it_behaves_like 'unauthorized' do
        before { request }
      end

      it 'does not create new user copyright' do
        expect { request }.not_to(change(UserCopyright, :count))
      end

      it 'does not link the user to the copyright' do
        expect { request }.not_to(change(copyright.user_copyrights, :count))
      end
    end

    context 'when specified user is not published' do
      let_it_be(:headers) { sign_in(current_user) }
      let_it_be(:user) { create(:user, :activated) }
      let_it_be(:params) do
        {
          user: {
            id: user.id
          }
        }
      end

      it_behaves_like 'not_found' do
        before { request }
      end

      it 'does not create new user copyright' do
        expect { request }.not_to(change(UserCopyright, :count))
      end

      it 'does not link the user to the copyright' do
        expect { request }.not_to(change(copyright.user_copyrights, :count))
      end
    end

    context 'when specified user is not found' do
      let_it_be(:headers) { sign_in(current_user) }
      let_it_be(:user) { create(:user, :published) }
      let_it_be(:params) do
        {
          user: {
            id: 'invalid-user-id'
          }
        }
      end

      it_behaves_like 'not_found' do
        before { request }
      end

      it 'does not create new user copyright' do
        expect { request }.not_to(change(UserCopyright, :count))
      end

      it 'does not link the user to the copyright' do
        expect { request }.not_to(change(copyright.user_copyrights, :count))
      end
    end

    context 'when work is not found' do
      let_it_be(:headers) { sign_in(current_user) }
      let_it_be(:user) { create(:user, :published) }
      let_it_be(:params) do
        {
          user: {
            id: user.id
          }
        }
      end
      let(:work_id) { 'invalid-work-id' }

      it_behaves_like 'not_found' do
        before { request }
      end

      it 'does not create new user copyright' do
        expect { request }.not_to(change(UserCopyright, :count))
      end

      it 'does not link the user to the copyright' do
        expect { request }.not_to(change(copyright.user_copyrights, :count))
      end
    end

    context 'when copyright is not found' do
      let_it_be(:headers) { sign_in(current_user) }
      let_it_be(:user) { create(:user, :published) }
      let_it_be(:params) do
        {
          user: {
            id: user.id
          }
        }
      end
      let(:copyright_id) { 'invalid-copyright-id' }

      it_behaves_like 'not_found' do
        before { request }
      end

      it 'does not create new user copyright' do
        expect { request }.not_to(change(UserCopyright, :count))
      end

      it 'does not link the user to the copyright' do
        expect { request }.not_to(change(copyright.user_copyrights, :count))
      end
    end

    context 'when specified copyright is linked to other work' do
      let_it_be(:headers) { sign_in(current_user) }
      let_it_be(:user) { create(:user, :published) }
      let_it_be(:other_work) { create(:work) }
      let_it_be(:other_copyright) { create(:copyright, work: other_work) }
      let_it_be(:params) do
        {
          user: {
            id: user.id
          }
        }
      end
      let(:copyright_id) { other_copyright.id }

      it_behaves_like 'not_found' do
        before { request }
      end

      it 'does not create new user copyright' do
        expect { request }.not_to(change(UserCopyright, :count))
      end

      it 'does not link the user to the copyright' do
        expect { request }.not_to(change(copyright.user_copyrights, :count))
      end
    end

    context 'when lack of id params' do
      let_it_be(:headers) { sign_in(current_user) }
      let_it_be(:user) { create(:user, :published) }
      let_it_be(:params) do
        {
          user: {
            hoge: 'fuga'
          }
        }
      end

      it_behaves_like 'bad_request' do
        before { request }
      end

      it 'does not create new user copyright' do
        expect { request }.not_to(change(UserCopyright, :count))
      end

      it 'does not link the user to the copyright' do
        expect { request }.not_to(change(copyright.user_copyrights, :count))
      end
    end

    context 'when id is nil' do
      let_it_be(:headers) { sign_in(current_user) }
      let_it_be(:user) { create(:user, :published) }
      let_it_be(:params) do
        {
          user: {
            id: nil
          }
        }
      end

      it_behaves_like 'not_found' do
        before { request }
      end

      it 'does not create new user copyright' do
        expect { request }.not_to(change(UserCopyright, :count))
      end

      it 'does not link the user to the copyright' do
        expect { request }.not_to(change(copyright.user_copyrights, :count))
      end
    end

    context 'when the copyright already have the user' do
      let_it_be(:headers) { sign_in(current_user) }
      let_it_be(:user) { create(:user, :published) }
      let_it_be(:params) do
        {
          user: {
            id: user.id
          }
        }
      end

      before_all do
        create(:user_copyright, copyright:, user:)
      end

      it_behaves_like 'unprocessable_entity' do
        before { request }
      end

      it 'does not create a new user copyright' do
        expect { request }.not_to(change(UserCopyright, :count))
      end

      it 'does not link the user to the copyright' do
        expect { request }.not_to(change(copyright.user_copyrights, :count))
      end
    end

    context 'when params is valid' do
      let_it_be(:headers) { sign_in(current_user) }
      let_it_be(:user) { create(:user, :published) }
      let_it_be(:params) do
        {
          user: {
            id: user.id
          }
        }
      end

      it_behaves_like 'no_content' do
        before { request }
      end

      it 'creates a new user copyright' do
        expect { request }.to change(UserCopyright, :count).by(1)
      end

      it 'links the user to the copyright' do
        expect { request }.to change(copyright.user_copyrights, :count).by(1)
      end

      it 'links the user by the signed-in user' do
        request

        expect(copyright.user_copyrights.first.created_user).to eq(current_user)
      end
    end
  end
end
