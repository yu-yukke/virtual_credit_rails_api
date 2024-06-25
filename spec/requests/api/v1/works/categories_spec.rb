require 'rails_helper'

RSpec.describe 'Api::V1::Works::Categories' do
  #   .########...#######...######..########......##.##....######..########..########....###....########.########
  #   .##.....##.##.....##.##....##....##.........##.##...##....##.##.....##.##.........##.##......##....##......
  #   .##.....##.##.....##.##..........##.......#########.##.......##.....##.##........##...##.....##....##......
  #   .########..##.....##..######.....##.........##.##...##.......########..######...##.....##....##....######..
  #   .##........##.....##.......##....##.......#########.##.......##...##...##.......#########....##....##......
  #   .##........##.....##.##....##....##.........##.##...##....##.##....##..##.......##.....##....##....##......
  #   .##.........#######...######.....##.........##.##....######..##.....##.########.##.....##....##....########

  describe 'POST #create' do
    subject(:request) do
      post api_v1_work_categories_path(work_id), headers:, params:
    end

    let_it_be(:user) { create(:user, :confirmed) }
    let_it_be(:work) { create(:work) }
    let_it_be(:category) { create(:category) }
    let(:work_id) { work.id }

    context 'when user does not signed-in' do
      let_it_be(:headers) { {} }
      let_it_be(:params) do
        {
          category: {
            id: category.id
          }
        }
      end

      it_behaves_like 'unauthorized' do
        before { request }
      end

      it 'does not create a new work category' do
        expect { request }.not_to(change(WorkCategory, :count))
      end

      it 'does not categorise the work to the category' do
        expect { request }.not_to(change(work.categories, :count))
      end
    end

    context 'when work is not found' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          category: {
            id: category.id
          }
        }
      end
      let(:work_id) { 'invalid-work-id' }

      it_behaves_like 'not_found' do
        before { request }
      end

      it 'does not create a new work category' do
        expect { request }.not_to(change(WorkCategory, :count))
      end

      it 'does not categorise the work to the category' do
        expect { request }.not_to(change(work.categories, :count))
      end
    end

    context 'when lack of id params' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          category: {
            hoge: 'fuga'
          }
        }
      end

      it_behaves_like 'bad_request' do
        before { request }
      end

      it 'does not create a new work category' do
        expect { request }.not_to(change(WorkCategory, :count))
      end

      it 'does not categorise the work to the category' do
        expect { request }.not_to(change(work.categories, :count))
      end
    end

    context 'when id is nil' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          category: {
            id: nil
          }
        }
      end

      it_behaves_like 'not_found' do
        before { request }
      end

      it 'does not create a new work category' do
        expect { request }.not_to(change(WorkCategory, :count))
      end

      it 'does not categorise the work to the category' do
        expect { request }.not_to(change(work.categories, :count))
      end
    end

    context 'when category is not found' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          category: {
            id: 'invalid-category-id'
          }
        }
      end

      it_behaves_like 'not_found' do
        before { request }
      end

      it 'does not create a new work category' do
        expect { request }.not_to(change(WorkCategory, :count))
      end

      it 'does not categorise the work to the category' do
        expect { request }.not_to(change(work.categories, :count))
      end
    end

    context 'when the work is already categorised to the category' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          category: {
            id: category.id
          }
        }
      end

      before_all do
        create(:work_category, work:, category:)
      end

      it_behaves_like 'unprocessable_entity' do
        before { request }
      end

      it 'does not create a new work category' do
        expect { request }.not_to(change(WorkCategory, :count))
      end

      it 'does not categorise the work to the category' do
        expect { request }.not_to(change(work.categories, :count))
      end
    end

    context 'when params is valid' do
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          category: {
            id: category.id
          }
        }
      end

      it_behaves_like 'no_content' do
        before { request }
      end

      it 'creates a new work category' do
        expect { request }.to change(WorkCategory, :count).by(1)
      end

      it 'categorises the work to the category' do
        expect { request }.to change(work.categories, :count).by(1)
      end

      it 'categorises the category by the user' do
        request

        expect(work.work_categories.first.created_user).to eq(user)
      end
    end
  end
end
