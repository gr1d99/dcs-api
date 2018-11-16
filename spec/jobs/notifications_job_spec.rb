require 'rails_helper'

RSpec.describe NotificationsJob, type: :job do
  describe '.perform' do
    context 'when type is invite new user' do
      let(:email) { Faker::Internet.email }
      let(:password) { Faker::Internet.password(10) }
      let(:params) { { email: email, password: password } }
      let(:type) { 'invite new user' }
      let(:options) do
        { mailer_name: NotificationMailer.name,
          action_name: 'invite_user',
          payload: {
            email: email,
            password: password } }
      end

      it 'enqueues job' do
        expect { described_class.perform_later(options: options) }
          .to have_enqueued_job
      end

      it 'sends email' do
        expect(all_emails.size).to be(0)
        perform_enqueued_jobs do
          described_class.perform_later(options: options)
        end
        expect(all_emails.size).to eq(1)
      end
    end

    context 'when type is send password reset link' do
      let(:user_email) { Faker::Internet.email }
      let(:link) { 'http://test.com/password?token=23d33' }
      let(:type) { 'send password reset link' }
      let(:options) do
        { mailer_name: NotificationMailer.name,
          action_name: 'send_password_reset_link',
          payload: { user_email: user_email,
                     link: link } }
      end

      it 'enqueues job' do
        expect do
          described_class.perform_later(options: options)
        end.to have_enqueued_job
      end

      it 'sends email' do
        perform_enqueued_jobs do
          described_class.perform_later(options: options)
        end

        expect(all_emails.size).to eq(1)
        expect(last_email.to).to match([user_email])
        expect(last_email.subject).to match(/Password Reset Instructions/)
      end
    end
  end
end
