class Email
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :bucket, touch: true

  field :headers
  field :from_email
  field :from_name
  field :to, type: Array
  field :attachments, type: Array
  field :email
  field :subject
  field :text
  field :html
  field :raw_msg

  index bucket_id: 1, created_at: -1

  index({ created_at: 1 }, { expire_after_seconds: 15.minutes })

  validates :bucket, presence: true

  after_create :bump_emails_recorded

  private

  def bump_emails_recorded
    REDIS.incr 'emails_recorded'
  end
end
