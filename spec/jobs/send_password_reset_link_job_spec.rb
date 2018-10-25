require 'rails_helper'

RSpec.describe SendPasswordResetLinkJob, type: :job do
  describe '#perform' do
    let(:user_email) { Faker::Internet.email }
    let(:link) { 'http://test.com/password?token=23d33' }

    it 'enqueues job' do
      expect do
        described_class.perform_later(user_email: user_email, link: link)
      end.to have_enqueued_job
    end

    it 'sends email' do
      perform_enqueued_jobs do
        described_class.perform_later(user_email: user_email, link: link)
      end

      expect(all_emails.size).to eq(1)
      expect(last_email.to).to match([user_email])
      expect(last_email.subject).to match(/Password Reset Instructions/)
    end
  end
end
