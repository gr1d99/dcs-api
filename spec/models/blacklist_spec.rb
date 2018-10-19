# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Blacklist, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:jti) }
  end

  describe 'methods' do
    describe '#jti_exists?' do
      it 'returns true when jti exists' do
        jti = SecureRandom.uuid
        create(:blacklist, jti: jti)
        expect(described_class.jti_exists?(jti)).to be_truthy
      end
    end
  end
end
