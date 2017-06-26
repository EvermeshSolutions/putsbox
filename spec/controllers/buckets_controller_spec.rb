require 'spec_helper'

RSpec.describe BucketsController, type: :controller do
  render_views

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
        html: '<p>Lorem Ipsum</p>'
      }
    }.with_indifferent_access]
  end

  let(:email) do
    event = mandrill_events.first
    email_params = event['msg']
    email_params['created_at'] = Time.at(event['ts'])
    Email.new(email_params)
  end

  let(:token) { email.email.gsub(/\@.*/, '') }
  let(:owner_token) { 'dcc7d3b5152e86064a46e4fef5160d173fe2edd1f1c9c793' }

  before do
    request.cookies[:owner_token] = owner_token
  end

  describe 'DELETE #clear' do
    specify do
      result = RecordEmail.call(token: token, email: email, owner_token: owner_token)
      bucket = result.bucket

      expect(bucket.emails.count).to eq(1)
      expect(bucket.emails_count).to eq(1)

      delete :clear, token: bucket.token

      bucket.reload

      expect(bucket.emails).to be_empty
      expect(bucket.emails_count).to eq(0)
    end
  end

  describe 'DELETE #destroy' do
    specify do
      result = RecordEmail.call(token: token, email: email, owner_token: owner_token)
      bucket = result.bucket

      expect {
        delete :destroy, token: bucket.token
      }.to change(Bucket, :count).by(-1)

      expect(response).to redirect_to(root_url)
    end
  end

  describe 'POST #create' do
    specify do
      expect {
        post :create
      }.to change(Bucket, :count).by(1)

      expect(response).to redirect_to(bucket_path(Bucket.last.token))
    end
  end

  describe 'GET #show' do
    specify do
      result = RecordEmail.call(token: token, email: email, owner_token: owner_token)
      bucket = result.bucket

      get :show, token: bucket.token

      expect(assigns(:bucket)).to eq(bucket)
      expect(assigns(:emails).to_a).to eq(bucket.emails.to_a)
    end

    context 'when not found' do
      it 'creates a new bucket' do
        token = 'not-found'
        expect {
          get :show, token: token

          expect(assigns(:bucket)).to eq(Bucket.find_by(token: token))
        }.to change(Bucket, :count).by(1)
      end
    end
  end
end
