class NotifyCount
  include Interactor

  def call
    return unless ENV['PUSHER_SECRET'] || ENV['PUSHER_APP_ID']

    Pusher.url = "http://3466d56fe2ef1fdd2943:#{ENV['PUSHER_SECRET']}@api.pusherapp.com/apps/#{ENV['PUSHER_APP_ID']}"

    Pusher["channel_#{context.bucket.token}"].trigger 'update_count', context.bucket.emails_count
  end
end
