require 'sidekiq/web'

Rails.application.routes.draw do
  scope :auth do
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
  end

  scope :admin do
    post 'add-user/', to: 'admins#add_user'
  end

  mount Sidekiq::Web => '/sidekiq'
end
