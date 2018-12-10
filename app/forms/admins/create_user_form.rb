module Admins
  class CreateUserForm < Reform::Form
    property :email
    property :password

    validates email: { required: true }
  end
end
