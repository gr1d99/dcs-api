module Api
  module V1
    class UserSerializer < ActiveModel::Serializer
      attributes :id, :email
    end
  end
end
