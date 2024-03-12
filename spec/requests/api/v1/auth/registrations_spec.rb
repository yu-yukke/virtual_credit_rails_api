require 'rails_helper'

RSpec.describe 'Api::V1::Auth::Registrations' do
  describe 'POST #create' do
    subject(:request) do
      post api_v1_user_registration_path, params:
    end

    context 'with valid params' do
      let_it_be(:params) do
        {
          email: 'virtualcredit.official@gmail.com',
          password: 'password',
          password_confirmation: 'password'
        }
      end

      it_behaves_like 'created' do
        before { request }
      end

      it 'creates new User' do
        expect { request }.to change(User, :count).by(1)
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

    context 'with empty params' do
      let_it_be(:params) { {} }

      it_behaves_like 'bad request' do
        before { request }
      end

      it 'does not create new User' do
        expect { request }.not_to change(User, :count)
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
          password_confirmation: 'password'
        }
      end

      it_behaves_like 'conflict' do
        before { request }
      end

      it 'does not create new User' do
        expect { request }.not_to change(User, :count)
      end

      it 'does not send a registration email' do
        expect { request }.not_to(change { ActionMailer::Base.deliveries.size })
      end
    end

    context 'with invalid email' do
      let_it_be(:params) do
        {
          email: 'invalid-email@hogehoge',
          password: 'password',
          password_confirmation: 'password'
        }
      end

      it_behaves_like 'unprocessable entity' do
        before { request }
      end

      it 'does not create new User' do
        expect { request }.not_to change(User, :count)
      end

      it 'does not send a registration email' do
        expect { request }.not_to(change { ActionMailer::Base.deliveries.size })
      end
    end

    context 'with short password' do
      let_it_be(:params) do
        {
          email: 'virtualcredit.official@gmail.com',
          password: 'passwor',
          password_confirmation: 'passwor'
        }
      end

      it_behaves_like 'unprocessable entity' do
        before { request }
      end

      it 'does not create new User' do
        expect { request }.not_to change(User, :count)
      end

      it 'does not send a registration email' do
        expect { request }.not_to(change { ActionMailer::Base.deliveries.size })
      end
    end

    context 'with long password' do
      let_it_be(:params) do
        {
          email: 'virtualcredit.official@gmail.com',
          password: 'passwordpasswordpasswordp',
          password_confirmation: 'passwordpasswordpasswordp'
        }
      end

      it_behaves_like 'unprocessable entity' do
        before { request }
      end

      it 'does not create new User' do
        expect { request }.not_to change(User, :count)
      end

      it 'does not send a registration email' do
        expect { request }.not_to(change { ActionMailer::Base.deliveries.size })
      end
    end
  end
end
