# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationMailer, type: :mailer do
  describe '.invite_user' do
    let(:payload) do
      { email: user_email,
        password: password }
    end

    before do
      described_class.with(payload: payload).invite_user.deliver_now
    end

    let(:user_email) { Faker::Internet.email }
    let(:password) { Faker::Internet.password(10) }

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

  describe 'new_password_link' do
    let(:user) { build(:user) }
    let(:payload) do
      { user_email: user.email,
        link: user.build_password_reset_url }
    end

    before do
      allow(User)
        .to receive(:fetch_host_and_port).and_return(%w[test 80])

      described_class
        .with(payload: payload)
        .send_password_reset_link
        .deliver_now
    end

    it 'renders headers' do
      expect(all_emails.size).to eq(1)
      expect(last_email.to).to match_array([user.email])
      expect(last_email.from).to match_array([ENV['ADMINS_DEFAULT_FROM_EMAIL']])
      expect(last_email.subject).to match(/Password Reset Instructions/)
    end

    it 'renders body' do
      message_body = 'Please click on the link below to reset your password'
      expect(last_email.body.encoded).to include(message_body)
      expect(last_email.body.encoded).to include(user.build_password_reset_url)
    end
  end
end
