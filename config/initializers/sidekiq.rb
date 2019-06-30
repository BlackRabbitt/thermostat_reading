# Use DB 4 for all job data
redis = { url: ENV['REDIS_SIDEKIQ_URL'] }

Sidekiq.configure_server do |config|
  config.redis = redis
end

Sidekiq.configure_client do |config|
  config.redis = redis
end
