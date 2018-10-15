Rails.application.routes.draw do
  scope :auth do
    post 'login', to: 'sessions#create'
  end

  scope :admin do
    post 'add-user/', to: 'admins#add_user'
  end
end
