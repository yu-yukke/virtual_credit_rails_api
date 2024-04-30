require 'rails_helper'

RSpec.describe 'Api::V1::UsersMe' do
  #   ..######...########.########......##.##....######..##.....##..#######..##......##
  #   .##....##..##..........##.........##.##...##....##.##.....##.##.....##.##..##..##
  #   .##........##..........##.......#########.##.......##.....##.##.....##.##..##..##
  #   .##...####.######......##.........##.##....######..#########.##.....##.##..##..##
  #   .##....##..##..........##.......#########.......##.##.....##.##.....##.##..##..##
  #   .##....##..##..........##.........##.##...##....##.##.....##.##.....##.##..##..##
  #   ..######...########....##.........##.##....######..##.....##..#######...###..###.

  describe 'GET #show' do
    subject(:request) do
      get me_api_v1_users_path, headers:
    end

    let_it_be(:user) { create(:user, :confirmed) }

    context 'when user does not signed-in' do
      let_it_be(:headers) { {} }

      it_behaves_like 'unauthorized' do
        before { request }
      end
    end

    context 'when user signed-in' do
      let_it_be(:headers) { sign_in(user) }

      it_behaves_like 'ok' do
        before { request }
      end

      it 'returns user correctly' do
        request
        body = response.parsed_body

        expect(body['data']['id']).to eq(user.id)
      end
    end
  end

  #   .########.....###....########..######..##.....##......##.##...##.....##.########..########.....###....########.########
  #   .##.....##...##.##......##....##....##.##.....##......##.##...##.....##.##.....##.##.....##...##.##......##....##......
  #   .##.....##..##...##.....##....##.......##.....##....#########.##.....##.##.....##.##.....##..##...##.....##....##......
  #   .########..##.....##....##....##.......#########......##.##...##.....##.########..##.....##.##.....##....##....######..
  #   .##........#########....##....##.......##.....##....#########.##.....##.##........##.....##.#########....##....##......
  #   .##........##.....##....##....##....##.##.....##......##.##...##.....##.##........##.....##.##.....##....##....##......
  #   .##........##.....##....##.....######..##.....##......##.##....#######..##........########..##.....##....##....########

  # rubocop:disable all
  xdescribe 'PATCH #update' do
    subject(:request) do
      patch me_api_v1_users_path, headers:, params:
    end

    context 'when user does not signed-in' do
      let_it_be(:user) { create(:user, :confirmed) }
      let_it_be(:headers) { {} }
      let_it_be(:params) do
        {
          name: Faker::Internet.username,
          slug: Faker::Internet.unique.slug,
          description: Faker::Lorem.paragraph,
          thumbnail_image: Faker::Avatar.image
        }
      end

      it_behaves_like 'unauthorized' do
        before { request }
      end

      it 'does not change name of the user' do
        expect { request }.not_to(change { user.reload.name })
      end

      it 'does not change slug of the user' do
        expect { request }.not_to(change { user.reload.slug })
      end

      it 'does not change description of the user' do
        expect { request }.not_to(change { user.reload.description })
      end

      it 'does not change thumbnail_image of the user' do
        expect { request }.not_to(change { user.reload.thumbnail_image })
      end
    end

    context 'with changing name of the new user' do
      let_it_be(:user) { create(:user, :new_user) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          name: Faker::Internet.username
        }
      end

      it_behaves_like 'unauthorized' do
        before { request }
      end

      it 'does not change name of the user' do
        expect { request }.not_to(change { user.reload.name })
      end
    end

    context 'with changing name of the new user to nil' do
      let_it_be(:user) { create(:user, :new_user) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          name: nil
        }
      end

      it_behaves_like 'unauthorized' do
        before { request }
      end

      it 'does not change name of the user' do
        expect { request }.not_to(change { user.reload.name })
      end
    end

    context 'with changing name of the new confirmed user' do
      let_it_be(:user) { create(:user, :new_user, :confirmed) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          name: Faker::Internet.username
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes name of the user' do
        expect { request }.to change { user.reload.name }.from(user.name).to(params[:name])
      end
    end

    context 'with changing name of the new confirmed user to nil' do
      let_it_be(:user) { create(:user, :new_user, :confirmed) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          name: nil
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes name of the user' do
        expect { request }.to change { user.reload.name }.from(user.name).to(params[:name])
      end
    end

    context 'with changing name of the confirmed user' do
      let_it_be(:user) { create(:user, :confirmed) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          name: Faker::Internet.username
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes name of the user' do
        expect { request }.to change { user.reload.name }.from(user.name).to(params[:name])
      end
    end

    context 'with changing name of the confirmed user to nil' do
      let_it_be(:user) { create(:user, :confirmed) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          name: nil
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes name of the user' do
        expect { request }.to change { user.reload.name }.from(user.name).to(params[:name])
      end
    end

    context 'with changing name of the activated user' do
      let_it_be(:user) { create(:user, :activated) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          name: Faker::Internet.username
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes name of the user' do
        expect { request }.to change { user.reload.name }.from(user.name).to(params[:name])
      end
    end

    context 'with changing name of the activated user to nil' do
      let_it_be(:user) { create(:user, :activated) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          name: nil
        }
      end

      it_behaves_like 'unprocessable entity' do
        before { request }
      end

      it 'does not change name of the user' do
        expect { request }.not_to(change { user.reload.name })
      end
    end

    context 'with changing name of the published user' do
      let_it_be(:user) { create(:user, :published) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          name: Faker::Internet.username
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes name of the user' do
        expect { request }.to change { user.reload.name }.from(user.name).to(params[:name])
      end
    end

    context 'with changing name of the published user to nil' do
      let_it_be(:user) { create(:user, :published) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          name: nil
        }
      end

      it_behaves_like 'unprocessable entity' do
        before { request }
      end

      it 'does not change name of the user' do
        expect { request }.not_to(change { user.reload.name })
      end
    end

    context 'with changing slug of the new user' do
      let_it_be(:user) { create(:user, :new_user) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          slug: Faker::Internet.unique.slug
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes slug of the user' do
        expect { request }.to change { user.reload.slug }.from(user.slug).to(params[:slug])
      end
    end

    context 'with changing slug of the new user to nil' do
      let_it_be(:user) { create(:user, :new_user) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          slug: nil
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes slug of the user' do
        expect { request }.to change { user.reload.slug }.from(user.slug).to(params[:slug])
      end
    end

    context 'with changing slug of the new user to slug already taken' do
      let_it_be(:user) { create(:user, :new_user) }
      let_it_be(:other_user) { create(:user, :confirmed) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          slug: other_user
        }
      end

      it_behaves_like 'unprocessable entity' do
        before { request }
      end

      it 'does not change slug of the user' do
        expect { request }.not_to(change { user.reload.slug })
      end
    end

    context 'with changing slug of the new confirmed user' do
      let_it_be(:user) { create(:user, :new_user, :confirmed) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          slug: Faker::Internet.unique.slug
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes slug of the user' do
        expect { request }.to change { user.reload.slug }.from(user.slug).to(params[:slug])
      end
    end

    context 'with changing slug of the new confirmed user to nil' do
      let_it_be(:user) { create(:user, :new_user, :confirmed) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          slug: nil
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes slug of the user' do
        expect { request }.to change { user.reload.slug }.from(user.slug).to(params[:slug])
      end
    end

    context 'with changing slug of the new confirmed user to slug already taken' do
      let_it_be(:user) { create(:user, :new_user, :confirmed) }
      let_it_be(:other_user) { create(:user, :confirmed) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          slug: other_user.slug
        }
      end

      it_behaves_like 'unprocessable entity' do
        before { request }
      end

      it 'does not change slug of the user' do
        expect { request }.not_to(change { user.reload.slug })
      end
    end

    context 'with changing slug of the confirmed user' do
      let_it_be(:user) { create(:user, :confirmed) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          slug: Faker::Internet.unique.slug
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes slug of the user' do
        expect { request }.to change { user.reload.slug }.from(user.slug).to(params[:slug])
      end
    end

    context 'with changing slug of the confirmed user to nil' do
      let_it_be(:user) { create(:user, :confirmed) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          slug: nil
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes slug of the user' do
        expect { request }.to change { user.reload.slug }.from(user.slug).to(params[:slug])
      end
    end

    context 'with changing slug of the confirmed user to slug already taken' do
      let_it_be(:user) { create(:user, :confirmed) }
      let_it_be(:other_user) { create(:user, :confirmed) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          slug: other_user.slug
        }
      end

      it_behaves_like 'unprocessable entity' do
        before { request }
      end

      it 'does not change slug of the user' do
        expect { request }.not_to(change { user.reload.slug })
      end
    end

    context 'with changing slug of the activated user' do
      let_it_be(:user) { create(:user, :activated) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          slug: Faker::Internet.unique.slug
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes slug of the user' do
        expect { request }.to change { user.reload.slug }.from(user.slug).to(params[:slug])
      end
    end

    context 'with changing slug of the activated user to nil' do
      let_it_be(:user) { create(:user, :activated) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          slug: nil
        }
      end

      it_behaves_like 'unprocessable entity' do
        before { request }
      end

      it 'does not change slug of the user' do
        expect { request }.not_to(change { user.reload.slug })
      end
    end

    context 'with changing slug of the activated user to slug already taken' do
      let_it_be(:user) { create(:user, :activated) }
      let_it_be(:other_user) { create(:user, :confirmed) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          slug: other_user.slug
        }
      end

      it_behaves_like 'unprocessable entity' do
        before { request }
      end

      it 'does not change slug of the user' do
        expect { request }.not_to(change { user.reload.slug })
      end
    end

    context 'with changing slug of the published user' do
      let_it_be(:user) { create(:user, :published) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          slug: Faker::Internet.unique.slug
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes slug of the user' do
        expect { request }.to change { user.reload.slug }.from(user.slug).to(params[:slug])
      end
    end

    context 'with changing slug of the published user to nil' do
      let_it_be(:user) { create(:user, :published) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          slug: nil
        }
      end

      it_behaves_like 'unprocessable entity' do
        before { request }
      end

      it 'does not change slug of the user' do
        expect { request }.not_to(change { user.reload.slug })
      end
    end

    context 'with changing slug of the published user to slug already taken' do
      let_it_be(:user) { create(:user, :published) }
      let_it_be(:other_user) { create(:user, :confirmed) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          slug: other_user.slug
        }
      end

      it_behaves_like 'unprocessable entity' do
        before { request }
      end

      it 'does not change slug of the user' do
        expect { request }.not_to(change { user.reload.slug })
      end
    end

    context 'with changing description of the new user' do
      let_it_be(:user) { create(:user, :new_user) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          description: Faker::Lorem.paragraph
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes description of the user' do
        expect { request }.to change { user.reload.description }.from(user.description).to(params[:description])
      end
    end

    context 'with changing description of the new user to nil' do
      let_it_be(:user) { create(:user, :new_user) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          description: nil
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes description of the user' do
        expect { request }.to change { user.reload.description }.from(user.description).to(params[:description])
      end
    end

    context 'with changing description of the new confirmed user' do
      let_it_be(:user) { create(:user, :new_user, :confirmed) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          description: Faker::Lorem.paragraph
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes description of the user' do
        expect { request }.to change { user.reload.description }.from(user.description).to(params[:description])
      end
    end

    context 'with changing description of the new confirmed user to nil' do
      let_it_be(:user) { create(:user, :new_user, :confirmed) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          description: nil
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes description of the user' do
        expect { request }.to change { user.reload.description }.from(user.description).to(params[:description])
      end
    end

    context 'with changing description of the confirmed user' do
      let_it_be(:user) { create(:user, :confirmed) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          description: Faker::Lorem.paragraph
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes description of the user' do
        expect { request }.to change { user.reload.description }.from(user.description).to(params[:description])
      end
    end

    context 'with changing description of the confirmed user to nil' do
      let_it_be(:user) { create(:user, :confirmed) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          description: nil
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes description of the user' do
        expect { request }.to change { user.reload.description }.from(user.description).to(params[:description])
      end
    end

    context 'with changing description of the activated user' do
      let_it_be(:user) { create(:user, :activated) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          description: Faker::Lorem.paragraph
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes description of the user' do
        expect { request }.to change { user.reload.description }.from(user.description).to(params[:description])
      end
    end

    context 'with changing description of the activated user to nil' do
      let_it_be(:user) { create(:user, :activated) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          description: nil
        }
      end

      it_behaves_like 'unprocessable entity' do
        before { request }
      end

      it 'does not change description of the user' do
        expect { request }.not_to(change { user.reload.description })
      end
    end

    context 'with changing description of the published user' do
      let_it_be(:user) { create(:user, :published) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          description: Faker::Lorem.paragraph
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes description of the user' do
        expect { request }.to change { user.reload.description }.from(user.description).to(params[:description])
      end
    end

    context 'with changing description of the published user to nil' do
      let_it_be(:user) { create(:user, :published) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          description: nil
        }
      end

      it_behaves_like 'unprocessable entity' do
        before { request }
      end

      it 'does not change description of the user' do
        expect { request }.not_to(change { user.reload.description })
      end
    end

    context 'with changing thumbnail_image of the new user' do
      let_it_be(:user) { create(:user, :new_user) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          thumbnail_image: Faker::Avatar.image
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes image of the user' do
        expect { request }.to change { user.reload.thumbnail_image }.from(user.thumbnail_image).to(params[:thumbnail_image])
      end
    end

    context 'with changing thumbnail_image of the new user to nil' do
      let_it_be(:user) { create(:user, :new_user) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          thumbnail_image: nil
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes thumbnail_image of the user' do
        expect { request }.to change { user.reload.thumbnail_image }.from(user.thumbnail_image).to(params[:thumbnail_image])
      end
    end

    context 'with changing image of the new confirmed user' do
      let_it_be(:user) { create(:user, :new_user, :confirmed) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          thumbnail_image: Faker::Avatar.image
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes thumbnail_image of the user' do
        expect { request }.to change { user.reload.thumbnail_image }.from(user.thumbnail_image).to(params[:thumbnail_image])
      end
    end

    context 'with changing thumbnail_image of the new confirmed user to nil' do
      let_it_be(:user) { create(:user, :new_user, :confirmed) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          thumbnail_image: nil
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes thumbnail_image of the user' do
        expect { request }.to change { user.reload.thumbnail_image }.from(user.thumbnail_image).to(params[:thumbnail_image])
      end
    end

    context 'with changing thumbnail_image of the confirmed user' do
      let_it_be(:user) { create(:user, :confirmed) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          thumbnail_image: Faker::Avatar.image
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes thumbnail_image of the user' do
        expect { request }.to change { user.reload.thumbnail_image }.from(user.thumbnail_image).to(params[:thumbnail_image])
      end
    end

    context 'with changing thumbnail_image of the confirmed user to nil' do
      let_it_be(:user) { create(:user, :confirmed) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          thumbnail_image: nil
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes thumbnail_image of the user' do
        expect { request }.to change { user.reload.thumbnail_image }.from(user.thumbnail_image).to(params[:thumbnail_image])
      end
    end

    context 'with changing thumbnail_image of the activated user' do
      let_it_be(:user) { create(:user, :activated) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          thumbnail_image: Faker::Avatar.image
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes thumbnail_image of the user' do
        expect { request }.to change { user.reload.thumbnail_image }.from(user.thumbnail_image).to(params[:thumbnail_image])
      end
    end

    context 'with changing thumbnail_image of the activated user to nil' do
      let_it_be(:user) { create(:user, :activated) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          thumbnail_image: nil
        }
      end

      it_behaves_like 'unprocessable entity' do
        before { request }
      end

      it 'does not change thumbnail_image of the user' do
        expect { request }.not_to(change { user.reload.thumbnail_image })
      end
    end

    context 'with changing thumbnail_image of the published user' do
      let_it_be(:user) { create(:user, :published) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          thumbnail_image: Faker::Avatar.image
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'changes thumbnail_image of the user' do
        expect { request }.to change { user.reload.thumbnail_image }.from(user.thumbnail_image).to(params[:thumbnail_image])
      end
    end

    context 'with changing thumbnail_image of the published user to nil' do
      let_it_be(:user) { create(:user, :published) }
      let_it_be(:headers) { sign_in(user) }
      let_it_be(:params) do
        {
          thumbnail_image: nil
        }
      end

      it_behaves_like 'unprocessable entity' do
        before { request }
      end

      it 'does not change thumbnail_image of the user' do
        expect { request }.not_to(change { user.reload.thumbnail_image })
      end
    end
  end
end
