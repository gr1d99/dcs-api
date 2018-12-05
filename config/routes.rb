require 'sidekiq/web'

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      scope :auth do
        post 'login', to: 'sessions#create'
        delete 'logout', to: 'sessions#destroy'
      end

      scope :passwords do
        get 'new', to: 'passwords#new', as: 'new_password'
        post 'create', to: 'passwords#create', as: 'passwords'
      end

      scope :admin do
        post 'add-user/', to: 'admins#add_user'
      end

      get 'verify', to: 'tokens#verify', as: 'verify_token'

    end
  end
  mount Sidekiq::Web => '/sidekiq'
end
