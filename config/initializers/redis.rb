class SafeRedis
  def initialize
    @redis = Redis.new url: ENV['REDIS_URL']
  rescue => ex
    # bad URI(is not URI?):  (URI::InvalidURIError)
    Rollbar.error(ex)
  end

  def method_missing(method, *args, &block)
    @redis.send method, *args, &block
  rescue => ex
    # Redis specific exceptions i.e. ECONNREFUSED
    Rollbar.error(ex)
  end
end

REDIS = SafeRedis.new
