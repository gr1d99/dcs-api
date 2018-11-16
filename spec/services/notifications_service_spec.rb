# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationsService do
  describe 'admin inviting new user #call' do
    context 'when all arguments are valid' do
      let(:type) { 'invite new user' }
      let(:email) { Faker::Internet.email }
      let(:password) { Faker::Internet.password }
      let(:params) { { email: email, password: password } }
      let(:options) do
        { mailer_name: NotificationMailer.name,
          action_name: 'invite_user',
          payload: params }
      end

      it 'enqueues invite job' do
        expect { described_class.call(type, params: params) }
          .to have_enqueued_job(NotificationsJob).with(options: options)
      end

      it 'sends email' do
        perform_enqueued_jobs do
          described_class.call(type, params: params)
        end

        expect(all_emails.size).to eq(1)
      end

      it 'sends invitation email with passed parameters' do
        perform_enqueued_jobs do
          described_class.call(type, params: params)
        end
        expect(last_email.to).to match_array([email])
        expect(last_email.body.encoded).to include(password)
      end
    end
  end

  describe 'sending password reset link' do
    let(:user) { build(:user) }
    let(:payload) do
      { user_email: user.email,
        link: user.build_password_reset_url }
    end
    let(:type) { 'send password reset link' }
    let(:options) do
      { mailer_name: NotificationMailer.name,
        action_name: 'send_password_reset_link',
        payload: payload }
    end

    before do
      allow(User)
        .to receive(:fetch_host_and_port).and_return(%w[test 80])
    end

    it 'enqueues invite job' do
      expect { described_class.call(type, params: payload) }
        .to have_enqueued_job(NotificationsJob).with(options: options)
    end

    it 'sends email' do
      perform_enqueued_jobs do
        described_class.call(type, params: payload)
      end

      expect(all_emails.size).to eq(1)
    end

    it 'sends email with expected parameters' do
      perform_enqueued_jobs do
        described_class.call(type, params: payload)
      end
      expect(last_email.to).to match_array([user.email])
      expect(last_email.body.encoded).to include(payload[:link])
    end
  end
end

