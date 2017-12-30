class NotifyCount
  include Interactor

  delegate :bucket, :email, to: :context
  delegate :token, to: :bucket

  def call
    return unless ENV['PUSHER_URL']

    channel_name = "channel_emails_#{token}"
    channel = pusher_client.channel_info(channel_name)

    return unless channel[:occupied]

    pusher_client.trigger(
      channel_name,
      'update_count',
      emails_count: bucket.emails_count,
      email: SimpleEmailSerializer.new(email)
    )
  rescue => ex
    Rollbar.error(ex)
  end

  private

  def pusher_client
    @_pusher_client ||= Pusher::Client.new(
      app_id: ENV['PUSHER_APP_ID'],
      key: ENV['PUSHER_KEY'],
      secret: ENV['PUSHER_SECRET'],
      cluster: ENV['PUSHER_CLUSTER'],
      encrypted: true
    )
  end
end
