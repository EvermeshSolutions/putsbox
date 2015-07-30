class Email
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :bucket

  field :headers
  field :from_email
  field :from_name
  field :to, type: Array
  field :email
  field :subject
  field :text
  field :html
  field :raw_msg

  # index created_at: 1, options { expireAfterSeconds: 604800 }
  index bucket_id: 1, created_at: -1

  validates :bucket, presence: true

  after_create :bump_emails_recorded

  private

  def bump_emails_recorded
    REDIS.incr 'emails_recorded'
  end
end
