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
end
