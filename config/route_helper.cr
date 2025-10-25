# This is used when generating URLs for your application
Lucky::RouteHelper.configure do |settings|
  if LuckyEnv.production?
    # Example: https://my_app.com
    settings.base_uri = ENV.fetch("APP_DOMAIN")
  else
    # Set domain to the default host/port in development/test
    app_domain = ENV["APP_DOMAIN"]? || "localhost"
    protocol = ENV["APP_DOMAIN"]? ? "https" : "http"
    settings.base_uri = "#{protocol}://#{app_domain}:#{Lucky::ServerSettings.port}"
  end
end
