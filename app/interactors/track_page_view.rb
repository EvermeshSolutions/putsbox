class TrackPageView
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

    tracker.pageview(title: bucket.token)
  rescue => ex
    Rollbar.error(ex)
  end

  private

  def bucket
    context.bucket
  end

  def request
    context.request
  end
end
