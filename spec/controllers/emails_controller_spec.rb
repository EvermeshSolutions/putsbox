require 'spec_helper'

RSpec.describe EmailsController, type: :controller do
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

  let(:bucket) do
    result = RecordEmail.call(token: token, email: email, owner_token: owner_token)
    result.bucket
  end

  before do
    request.cookies[:owner_token] = owner_token
    allow(controller).to receive(:redirect_from_root_domain)
  end

  describe 'GET #show' do
    context 'when format text' do
      it 'renders text' do
        get :show, token: bucket.token, id: email.id.to_s, format: :text, subdomain: 'preview'

        expect(response.body).to eq(email.text)
      end
    end

    context 'when format HTML' do
      it 'renders HTML' do
        get :show, token: bucket.token, id: email.id.to_s, format: :html, subdomain: 'preview'

        expect(response.body).to eq(email.html)
      end
    end

    context 'when format JSON' do
      it 'renders JSON' do
        get :show, token: bucket.token, id: email.id.to_s, format: :json, subdomain: 'preview'

        expect(response.body).to eq(EmailSerializer.new(email).to_json)
      end
    end

    context 'when looking for last' do
      it 'renders last' do
        result = RecordEmail.call(token: token, email: email, owner_token: owner_token)

        get :show, token: bucket.token, id: 'last', format: :json, subdomain: 'preview'

        expect(JSON.parse(response.body)['id']).to eq(result.email.id.to_s)
      end
    end
  end
end
