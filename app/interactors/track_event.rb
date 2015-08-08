class TrackEvent
  include Interactor

  def call
    return unless ENV['GA']

    options = {
      hostname:    request.host,
      path:        request.path,
      user_id:     request.session.id,
      user_ip:     request.remote_ip,
      user_agent:  request.user_agent,
      referrer:    request.referer
    }

    tracker = Staccato.tracker(ENV['GA'], nil, options)

    event = tracker.build_event(category: 'Emails',
                                action: 'record',
                                label: bucket.token,
                                non_interactive: true)

    event.add_measurement(:email, token: bucket.token)

    event.track!
  rescue => e
    Rails.logger.error(e)
  end

  private

  def bucket
    context.bucket
  end

  def request
    context.request
  end
end
