if Rails.env.development?
  User.create(email: 'test@example.com',
              password: 'password1234')
  User.create(email: 'test-admin@example.com',
              password: 'password1234',
              is_admin: true)
end
