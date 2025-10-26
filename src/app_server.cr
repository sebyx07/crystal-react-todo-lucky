require "openssl"

class AppServer < Lucky::BaseAppServer
  # Learn about middleware with HTTP::Handlers:
  # https://luckyframework.org/guides/http-and-routing/http-handlers
  def middleware : Array(HTTP::Handler)
    [
      Lucky::RequestIdHandler.new,
      Lucky::ForceSSLHandler.new,
      Lucky::HttpMethodOverrideHandler.new,
      Lucky::LogHandler.new,
      Lucky::ErrorHandler.new(action: Errors::Show),
      Lucky::RemoteIpHandler.new,
      # Serve static files BEFORE routes so /js/app.js doesn't match catch-all route
      Lucky::StaticCompressionHandler.new("./public", file_ext: "gz", content_encoding: "gzip"),
      Lucky::StaticFileHandler.new("./public", fallthrough: true, directory_listing: false),
      Lucky::RouteHandler.new,
      Lucky::RouteNotFoundHandler.new,
    ] of HTTP::Handler
  end

  def protocol
    ssl_enabled? ? "https" : "http"
  end

  def listen
    if ssl_enabled?
      server.bind_tls(host, port, ssl_context, reuse_port: false)
      server.listen
    else
      server.listen(host, port, reuse_port: false)
    end
  end

  private def ssl_enabled?
    ENV["SSL_ENABLED"]? == "true"
  end

  private def ssl_context
    context = OpenSSL::SSL::Context::Server.new
    context.certificate_chain = ENV.fetch("SSL_CERT_PATH")
    context.private_key = ENV.fetch("SSL_KEY_PATH")
    context
  end
end
