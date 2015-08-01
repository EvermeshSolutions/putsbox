require 'spec_helper'

RSpec.describe CreateOrRetrieveBucket do
  describe '#call' do
    it 'creates a bucket' do
      expect {
        described_class.call(token: 'new_token')
      }.to change(Bucket, :count).by(1)
    end

    context 'when existing bucket' do
      let!(:bucket) { Bucket.create }

      it 'returns a bucket' do
        expect {
          described_class.call(token: bucket.token)
        }.to_not change(Bucket, :count)
      end
    end
  end
end
