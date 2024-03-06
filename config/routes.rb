Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :release_notes, only: %i[index]
    end
  end
end
