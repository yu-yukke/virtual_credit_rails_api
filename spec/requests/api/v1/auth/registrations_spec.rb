require 'rails_helper'

RSpec.describe 'Api::V1::Auth::Registrations' do
  #   .########...#######...######..########......##.##....######..########..########....###....########.########
  #   .##.....##.##.....##.##....##....##.........##.##...##....##.##.....##.##.........##.##......##....##......
  #   .##.....##.##.....##.##..........##.......#########.##.......##.....##.##........##...##.....##....##......
  #   .########..##.....##..######.....##.........##.##...##.......########..######...##.....##....##....######..
  #   .##........##.....##.......##....##.......#########.##.......##...##...##.......#########....##....##......
  #   .##........##.....##.##....##....##.........##.##...##....##.##....##..##.......##.....##....##....##......
  #   .##.........#######...######.....##.........##.##....######..##.....##.########.##.....##....##....########

  describe 'POST #create' do
    subject(:request) do
      post api_v1_user_registration_path, params:
    end

    context 'with valid params' do
      let_it_be(:params) do
        {
          email: 'virtualcredit.official@gmail.com',
          password: 'password',
          password_confirmation: 'password',
          confirm_success_url: 'https://google.com'
        }
      end

      it_behaves_like 'ok' do
        before { request }
      end

      it 'creates new User' do
        expect { request }.to change(User, :count).by(1)
      end

      it 'creates new User is not activated' do
        request

        new_user = User.order(created_at: :desc).first

        expect(new_user.activated_at).to be_nil
      end

      it 'creates new Social' do
        expect { request }.to change(Social, :count).by(1)
      end

      it 'creates new Social associated with new User' do
        request

        new_user = User.order(created_at: :desc).first
        new_social = Social.order(created_at: :desc).first

        expect(new_social.user).to eq(new_user)
      end

      it 'sends a registration email' do
        expect { request }.to change { ActionMailer::Base.deliveries.size }.by(1)
      end

      it 'sends an email to new user' do
        request

        last_mail = ActionMailer::Base.deliveries.last
        new_user = User.order(created_at: :desc).first

        expect(last_mail.to).to match_array(*new_user.email)
      end
    end

    context 'when params is empty' do
      let_it_be(:params) { {} }

      it_behaves_like 'bad_request' do
        before { request }
      end

      it 'does not create new User' do
        expect { request }.not_to change(User, :count)
      end

      it 'does not create new Social' do
        expect { request }.not_to change(Social, :count)
      end

      it 'does not send a registration email' do
        expect { request }.not_to(change { ActionMailer::Base.deliveries.size })
      end
    end

    context 'when lack of email' do
      let_it_be(:params) do
        {
          password: 'password',
          password_confirmation: 'password',
          confirm_success_url: 'https://google.com'
        }
      end

      it_behaves_like 'bad_request' do
        before { request }
      end

      it 'does not create new User' do
        expect { request }.not_to change(User, :count)
      end

      it 'does not create new Social' do
        expect { request }.not_to change(Social, :count)
      end

      it 'does not send a registration email' do
        expect { request }.not_to(change { ActionMailer::Base.deliveries.size })
      end
    end

    context 'when lack of password' do
      let_it_be(:params) do
        {
          email: 'virtualcredit.official@gmail.com',
          password_confirmation: 'password',
          confirm_success_url: 'https://google.com'
        }
      end

      it_behaves_like 'bad_request' do
        before { request }
      end

      it 'does not create new User' do
        expect { request }.not_to change(User, :count)
      end

      it 'does not create new Social' do
        expect { request }.not_to change(Social, :count)
      end

      it 'does not send a registration email' do
        expect { request }.not_to(change { ActionMailer::Base.deliveries.size })
      end
    end

    context 'when lack of password_confirmation' do
      let_it_be(:params) do
        {
          email: 'virtualcredit.official@gmail.com',
          password: 'password',
          confirm_success_url: 'https://google.com'
        }
      end

      it_behaves_like 'bad_request' do
        before { request }
      end

      it 'does not create new User' do
        expect { request }.not_to change(User, :count)
      end

      it 'does not create new Social' do
        expect { request }.not_to change(Social, :count)
      end

      it 'does not send a registration email' do
        expect { request }.not_to(change { ActionMailer::Base.deliveries.size })
      end
    end

    context 'when lack of confirm_success_url' do
      let_it_be(:params) do
        {
          email: 'virtualcredit.official@gmail.com',
          password: 'password',
          password_confirmation: 'password'
        }
      end

      it_behaves_like 'bad_request' do
        before { request }
      end

      it 'does not create new User' do
        expect { request }.not_to change(User, :count)
      end

      it 'does not create new Social' do
        expect { request }.not_to change(Social, :count)
      end

      it 'does not send a registration email' do
        expect { request }.not_to(change { ActionMailer::Base.deliveries.size })
      end
    end

    context 'when email is already in use' do
      let_it_be(:user) { create(:user) }
      let_it_be(:params) do
        {
          email: user.email,
          password: 'password',
          password_confirmation: 'password',
          confirm_success_url: 'https://google.com'
        }
      end

      it_behaves_like 'unprocessable_entity' do
        before { request }
      end

      it 'does not create new User' do
        expect { request }.not_to change(User, :count)
      end

      it 'does not create new Social' do
        expect { request }.not_to change(Social, :count)
      end

      it 'does not send a registration email' do
        expect { request }.not_to(change { ActionMailer::Base.deliveries.size })
      end
    end
  end
end
