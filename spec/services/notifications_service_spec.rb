# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationsService do
  describe 'admin inviting new user #call' do
    context 'when all arguments are valid' do
      let(:type) { 'invite new user' }
      let(:email) { Faker::Internet.email }
      let(:password) { Faker::Internet.password }
      let(:params) { { email: email, password: password } }

      it 'enqueues invite job' do
        expect { described_class.call(type, params: params) }
          .to have_enqueued_job(InviteJob)
          .with(email: email, password: password)
      end

      it 'sends invitation email' do
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
end
