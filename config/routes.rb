Rails.application.routes.draw do
  # letter_opener
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks], controllers: {
        registrations: 'api/v1/auth/registrations',
        confirmations: 'api/v1/auth/confirmations',
        sessions: 'api/v1/auth/sessions'
      }

      resources :assets, only: %i[create]

      resources :categories, only: %i[create]

      resources :release_notes, only: %i[index]

      resource :social, only: %i[update]

      resources :skills, only: %i[index create]

      resources :tags, only: %i[create]

      resources :users, only: %i[index] do
        collection do
          get '/me', to: 'users_me#show'
          patch '/me', to: 'users_me#update'
        end
      end

      resources :user_skills, only: %i[create]

      resources :works, only: %i[index create show] do
        resources :assets, only: %i[create], module: :works

        resources :categories, only: %i[create], module: :works

        resources :copyrights, only: %i[create], module: :works do
          resources :users, only: %i[create], module: :copyrights
        end

        resources :likes, only: %i[create], module: :works

        resources :tags, only: %i[create], module: :works

        resources :work_images, only: %i[create], module: :works
      end
    end
  end
end
