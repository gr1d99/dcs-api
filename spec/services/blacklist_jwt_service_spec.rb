# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BlacklistJwtService do
  describe '#call' do
    let(:payload) { { email: build_stubbed(:user).email } }
    let(:jwt) { DcsJwt.encode(payload: payload) }

    context 'when jti exists' do
      it 'adds jti blacklisted jtis' do
        expect { described_class.call(jwt: jwt) }
          .to change(Blacklist, :count).by(1)
      end
    end
  end
end
