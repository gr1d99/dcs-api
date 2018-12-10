module Users
  class BlacklistJwtService
    def initialize(jwt:)
      @jwt = jwt
    end

    def self.call(jwt:)
      new(jwt: jwt).call
    end

    def call
      blacklist
    end

    private

    attr_reader :jwt

    def jti_blacklisted?
      Blacklist.jti_exists?(jti)
    end

    def jti
      DcsJwt.decode(jwt: jwt)[0]['jti']
    end

    def blacklist
      Blacklist.create!(jti: jti)
    end
  end
end
