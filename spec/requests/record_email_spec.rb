require 'spec_helper'

RSpec.describe 'Record Email', type: :request do
  let(:mandrill_events) do
    [{
      event: 'inbound',
      ts: Time.now.to_i,
      msg: {
        headers: [],
        from_email: 'from@example.com',
        from_name: 'John',
        to: [['to@example.com', nil]],
        email: 'to@example.com',
        subject: 'Hello',
        text: 'Lorem Ipsum',
        html: '<p>Lorem Ipsum</p>',
        raw_msg: '...'
      }
    }.with_indifferent_access]
  end

  it 'creates a new bucket' do
    expect {
      post '/record', mandrill_events: JSON.dump(mandrill_events)
    }.to change(Bucket, :count).by(1)

    expect(response).to be_ok
  end

  context 'when bucket already exists' do
    let!(:bucket) { Bucket.create(token: 'to') }

    it 'updates a bucket' do
      expect {
        post '/record', mandrill_events: JSON.dump(mandrill_events)
      }.to change(Bucket, :count).by(0)

      expect(bucket.reload.emails_count).to eq(1)
      expect(response).to be_ok
    end
  end
end
