module Users
  class AuthorizeUserService
    def initialize(auth_token:)
      @auth_token = auth_token
    end

    def call
      user
    end

    def self.call(auth_token:)
      new(auth_token: auth_token).call
    end

    private

    def jwt
      auth_token.split.last
    end

    def payload
      DcsJwt.decode(jwt: jwt)[0]
    end

    def user
      User.find_by_email(payload['email'])
    end

    attr_reader :auth_token
  end
end
