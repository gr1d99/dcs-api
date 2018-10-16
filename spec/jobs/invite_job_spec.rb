require 'rails_helper'

RSpec.describe InviteJob, type: :job do
  let(:email) { Faker::Internet.email }
  let(:password) { Faker::Internet.password(10) }

  describe '.perform' do
    it 'enqueues job' do
      expect { described_class.perform_later(email: email, password: password) }
        .to have_enqueued_job
    end

    it 'sends email' do
      expect(all_emails.size).to be(0)

      perform_enqueued_jobs do
        described_class.perform_later(email: email, password: password)
      end

      expect(all_emails.size).to eq(1)
    end
  end
end
