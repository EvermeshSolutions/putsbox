class Bucket
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user

  field :token
  field :owner_token

  index token: 1
  index owner_token: 1

  has_many :emails, dependent: :destroy, order: :created_at.desc

  before_create :generate_token

  index({ updated_at: 1 }, { expire_after_seconds: 1.week })

  def clear_history
    emails.delete_all
  end

  def last_email_at
    emails.order(:created_at.desc).first.try(:created_at)
  end

  def first_email_at
    emails.order(:created_at.asc).first.try(:created_at)
  end

  def emails_count
    emails.count
  end

  private

  def generate_token
    self.token ||= loop do
      random_token = Faker::Internet.email.gsub(/\@.*/, '').gsub('.', '_')
      break random_token unless Bucket.where(token: random_token).exists?
    end
  end
end
