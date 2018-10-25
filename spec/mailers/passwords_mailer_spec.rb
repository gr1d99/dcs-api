# frozen_string_literal: true

require "rails_helper"

RSpec.describe PasswordsMailer, type: :mailer do
  describe 'new_password_link' do
    let(:user) { build(:user) }

    before do
      allow(User)
        .to receive(:fetch_host_and_port).and_return(%w[test 80])

      described_class
        .with(user_email: user.email, link: user.build_password_reset_url)
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
