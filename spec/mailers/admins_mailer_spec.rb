# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdminsMailer, type: :mailer do
  before do
    described_class.with(
      email: user_email,
      password: password
    ).invite.deliver_now
  end

  let(:user_email) { Faker::Internet.email }
  let(:password) { Faker::Internet.password(10) }

  describe '.invite' do
    it 'renders headers' do
      expect(all_emails.size).to eq(1)
      expect(last_email.to).to match_array([user_email])
      expect(last_email.from).to match_array([ENV['ADMINS_DEFAULT_FROM_EMAIL']])
      expect(last_email.subject).to match(/Welcome to DCS/)
    end

    it 'renders body' do
      expect(last_email.body.encoded).to include("Email: #{user_email}")
      expect(last_email.body.encoded).to include("Password: #{password}")
    end
  end
end
