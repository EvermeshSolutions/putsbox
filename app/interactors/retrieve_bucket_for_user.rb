class RetrieveBucketForUser
  include Interactor

  def call
    bucket = Bucket.find_by(token: context.token)

    if [bucket.owner_token, bucket.user_id].compact.none? && [context.owner_token, context.user_id].compact.any?
      bucket.update_attributes owner_token: context.owner_token, user_id: context.user_id
    end

    context.bucket = bucket
  end
end
