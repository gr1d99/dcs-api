# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password_digest) }
    it { should validate_uniqueness_of(:email) }
  end

  describe 'custom methods' do
    let(:user) { build(:user) }

    describe '#build_password_reset_token' do
      it 'returns token' do
        expect(user.build_password_reset_token).not_to be_nil
      end

      it 'saves generated token' do
        password_reset_token = user.build_password_reset_token
        expect(user.password_reset_token).to eq(password_reset_token)
      end
    end

    describe '#build_password_reset_url' do
      before do
        allow(described_class)
          .to receive(:fetch_host_and_port).and_return(%w[test 80])
      end

      it 'generates url' do
        user.build_password_reset_token
        expect(user.build_password_reset_url).not_to be_nil
      end
    end

    describe '#fetch_host_and_port' do
      it 'returns production host and port value' do
        expect(described_class.fetch_host_and_port('production'))
          .to match(%w[dcs-api 80])
      end

      it 'returns development host and port value' do
        expect(described_class.fetch_host_and_port('development'))
          .to match(%w[localhost 3000])
      end
    end

    describe '#verify_token?' do
      it 'returns true when token exists' do
        allow(User).to receive(:token_valid?).and_return(true)
        expect(User.token_valid?('password_reset', SecureRandom.urlsafe_base64))
          .to eq(true)
      end

      it 'returns false when token does not exists' do
        allow(User).to receive(:token_valid?).and_return(false)
        expect(User.token_valid?('password_reset', SecureRandom.urlsafe_base64))
          .to eq(false )
      end

    end
  end
end
