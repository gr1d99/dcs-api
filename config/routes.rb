Rails.application.routes.draw do
  devise_for :users,
             path: 'users',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout'
             },
             controllers: {
               sessions: 'sessions',
               passwords: 'passwords'
             },
             skip: [:registrations]
end
