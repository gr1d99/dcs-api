# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admins::CreateUserService do
  let(:email) { 'test@example.com' }

  context 'when email is valid' do
    it 'return true for success status' do
      result = described_class.call(email: email)
      expect(result.success?).to be_truthy
    end
    it 'sends invitation to new user' do
      perform_enqueued_jobs do
        described_class.call(email: email)
      end
      expect(last_email.to).to match_array([email])
      expect(last_email.subject).to match(/Welcome to DCS/)

    end
  end

  context 'when email value is missing' do
    it 'returns fail for success status' do
      result = described_class.call(email: '')
      expect(result.success?).to be_falsey
    end
    it 'does not send invitation' do
      expect(last_email).to be_nil
    end
  end

  context 'when email parameter is nil' do
    it 'returns fails for success status' do
      result = described_class.call(email: nil)
      expect(result.success?).to be_falsey
    end
    it 'does not send invitation' do
      expect(last_email).to be_nil
    end
  end
end