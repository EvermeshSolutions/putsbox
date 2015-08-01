class Bucket
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user

  field :token
  field :owner_token
  field :last_email_at, type: Time
  field :first_email_at, type: Time
  field :emails_count, type: Integer, default: 0

  index token: 1
  index owner_token: 1

  has_many :emails, dependent: :destroy, order: :created_at.desc

  before_create :generate_token

  def last_email
    emails.order(:created_at.desc).first
  end

  def clear_history
    update_attributes last_email_at: nil, first_email_at: nil, emails_count: 0
    emails.delete_all
  end

  private

  def generate_token
    self.token ||= loop do
      random_token = Faker::Internet.email.gsub(/\@.*/, '').gsub('.', '_')
      break random_token unless Bucket.where(token: random_token).exists?
    end
  end
end
