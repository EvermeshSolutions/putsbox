class CreateOrRetrieveBucket
  include Interactor

  def call
    if context.token && (bucket = (Bucket.find_by(token: context.token) rescue nil))
      return context.bucket = bucket
    end

    new_bucket = { owner_token: context.owner_token, user_id: context.user_id, token: context.token }

    context.bucket = Bucket.create(new_bucket)
  end
end
