Rails.application.routes.draw do
  scope :auth do
    post 'login', to: 'sessions#create'
  end
end
