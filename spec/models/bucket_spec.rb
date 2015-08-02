require 'spec_helper'

RSpec.describe Bucket do
  describe '.create' do
    it 'creates a bucket' do
      my_token = 'my_token'
      bucket = described_class.create(token: my_token)

      expect(bucket.token).to eq(my_token)
    end

    context 'when token is absent' do
      it 'assigns a token' do
        bucket = described_class.create

        expect(bucket.token).to be_present
      end
    end
  end

  describe '#last_email_at' do
    it 'returns last_email_at' do
      bucket = described_class.create
      bucket.emails << Email.create
      bucket.emails << (last = Email.create)

      expect(bucket.last_email_at).to eq(last.reload.created_at)
    end

    context 'when no emails' do
      it 'returns nil' do
        bucket = described_class.create

        expect(bucket.last_email_at).to be_nil
      end
    end
  end

  describe '#first_email_at' do
    it 'returns first_email_at' do
      bucket = described_class.create
      bucket.emails << (first = Email.create)
      bucket.emails << Email.create

      expect(bucket.first_email_at).to eq(first.reload.created_at)
    end

    context 'when no emails' do
      it 'returns nil' do
        bucket = described_class.create

        expect(bucket.first_email_at).to be_nil
      end
    end
  end

  describe '#emails_count' do
    it 'returns count' do
      bucket = described_class.create emails: [Email.create]

      expect(bucket.emails_count).to eq(1)
    end

    context 'when no emails' do
      it 'returns 0' do
        bucket = described_class.create

        expect(bucket.emails_count).to eq(0)
      end
    end
  end
end
