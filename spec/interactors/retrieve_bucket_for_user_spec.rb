require 'spec_helper'

RSpec.describe RetrieveBucketForUser do
  describe '#call' do
    let!(:bucket) { Bucket.create }
    let(:owner_token) { '55bcdb2d5061622089000000' }
    let(:user_id) { '55bcdb245061622086000000' }

    it 'assigns user as owner' do
      result = described_class.call(token: bucket.token,
                                    owner_token: owner_token,
                                    user_id: user_id)

      expect(result.bucket).to have_attributes(token: bucket.token,
                                               owner_token: owner_token,
                                               user_id: BSON::ObjectId.from_string(user_id))
    end

    context 'when bucket has an owner' do
      let!(:bucket) { Bucket.create(owner_token: '55bcdcc65061622136000000',
                                    user_id: BSON::ObjectId.from_string('55bcdcd65061622138000000')) }

      it 'keeps original owner' do
        result = described_class.call(token: bucket.token,
                                      owner_token: owner_token,
                                      user_id: user_id)

        expect(result.bucket).to_not have_attributes(owner_token: owner_token,
                                                     user_id: BSON::ObjectId.from_string(user_id))
      end
    end
  end
end
