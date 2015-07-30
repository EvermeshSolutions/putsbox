class UpdateBucketStats
  include Interactor

  def call
    bucket.atomically do
      now = Time.now

      bucket.inc(emails_count: 1)
      bucket.set(last_email_at: now)
      bucket.set(first_email_at: now) unless bucket.first_email_at
    end
  end

  private

  def bucket
    context.bucket
  end
end
