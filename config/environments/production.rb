# frozen_string_literal: true

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available in either ENV["RAILS_MASTER_KEY"]
  # or in config/master.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # `config.assets.precompile` and `config.assets.version` have moved to config/initializers/assets.rb

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :local

  # Mount Action Cable outside main process or domain
  # config.action_cable.mount_path = nil
  # config.action_cable.url = 'wss://example.com/cable'
  # config.action_cable.allowed_request_origins = [ 'http://example.com', /http:\/\/example.*/ ]

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :debug

  # Prepend all log lines with the following tags.
  config.log_tags = [:request_id]

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Use a real queuing backend for Active Job (and separate queues per environment)
  # config.active_job.queue_adapter     = :resque
  # config.active_job.queue_name_prefix = "voting_#{Rails.env}"

  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = [I18n.default_locale]

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Use a different logger for distributed setups.
  # require 'syslog/logger'
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'app-name')

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  PUBLIC_URL = ENV['APPLICATION_URL']
  SCHEME = 'https'

  config.action_mailer.asset_host = "#{SCHEME}://#{PUBLIC_URL}"
  config.action_mailer.default charset: 'utf-8'
  config.action_mailer.default_url_options = { host: PUBLIC_URL }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.smtp_settings = {
    address: 'smtp.gmail.com',
    port: '587',
    domain: 'gmail.com',
    authentication: 'plain',
    enable_starttls_auto: true,
    openssl_verify_mode: 'none',
    user_name: ENV['FTEK_USERNAME'],
    password: ENV['FTEK_PASSWORD']
  }
  
  config.x.saml_configure = Proc.new do |settings|
    # assertion_consumer_service_url is required starting with ruby-saml 1.4.3: https://github.com/onelogin/ruby-saml#updating-from-142-to-143
    settings.assertion_consumer_service_url     = "#{SCHEME}://#{PUBLIC_URL}/users/saml/auth"
    settings.assertion_consumer_service_binding = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"
    settings.protocol_binding                   = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"
    settings.name_identifier_format              = "urn:oasis:names:tc:SAML:2.0:nameid-format:transient"
    settings.issuer                             = "#{SCHEME}://#{PUBLIC_URL}/users/saml/metadata"
    settings.authn_context                      = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"
    settings.idp_slo_target_url                 = "https://idp.chalmers.se/adfs/ls/"
    settings.idp_sso_target_url                 = "https://idp.chalmers.se/adfs/ls/"
    settings.idp_cert                           = "MIIDqTCCApGgAwIBAgIUJvJG3zA1H52oNzOAXoQe57Mk9AwwDQYJKoZIhvcNAQELBQAwZDELMAkGA1UEBhMCU0UxDDAKBgNVBAgMA1ZHUjEMMAoGA1UEBwwDR0JHMREwDwYDVQQKDAhDaGFsbWVyczEMMAoGA1UECwwDSVRBMRgwFgYDVQQDDA9pZHAuY2hhbG1lcnMuc2UwHhcNMjAwNzIwMTIzNTI4WhcNNDYwMzExMTIzNTI4WjBkMQswCQYDVQQGEwJTRTEMMAoGA1UECAwDVkdSMQwwCgYDVQQHDANHQkcxETAPBgNVBAoMCENoYWxtZXJzMQwwCgYDVQQLDANJVEExGDAWBgNVBAMMD2lkcC5jaGFsbWVycy5zZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAPuaynUvXy5n8He3Jefpxz2ELpaXM9mzhiLlF6NK41XJeLo7OsLD0l3kQH2AXQMXvkKV0hoh/dwxlUImj/jCCpBpdF8z4LmYtz4/+FNYq+fMSCf/TkhB2AbLJbPD+AT+yrrlPr3R7Smjd0emtgPWM20NcbBflTM9Uh2jZMeQLHSJu3dIoRW4cdZOKgwonVMTaocccDxxEMQUqE6k/mYCFmCVEYIGLBnkDPSixNIDtzY+WY70bN12HLwLhPhxCz8wS3C/NhXF5gNoChXcfUB3Fxw4lY4GuH49D5cwyvtVNNJR1uCVJFlSbj+xe9bjqjkKwal78iPcxSTLD1SBxPeia1kCAwEAAaNTMFEwHQYDVR0OBBYEFLHkg8AuJUdGvsY0mwofGr9cHWGfMB8GA1UdIwQYMBaAFLHkg8AuJUdGvsY0mwofGr9cHWGfMA8GA1UdEwEB/wQFMAMBAf8wDQYJKoZIhvcNAQELBQADggEBAC2nyf2NAWnIpedq7cA4tJsodhxDFNSS6tPPav4MypL2rC46a0W/YL5QJn32qoFTMJNfLglu2NWUfUeSKD22XlH/PKV4z/BPFtC9EXNmNbp2aBXSnoC5rmNr1VL/RgTPHL9ebx7BkpM+y/zAbLOeyKtlfumzDt30PrZAImcIHOp7LqkZjmb4RQFHWZc62pzbNjrXhywbTK3ry6K0U7gk1SvWxjD6U/cWSASaYotqWJryWoo7pVcLTGUUYmfCNi+IGINW+KRhUuH4W7+1STwh104kedGkUcbhXaNGtEpqQPwhNFnEnKZFiKy74rN/Ks2Puvinr2CeoSlfk1mRQSkiGxk="
    # settings.idp_cert_fingerprint                = "62:21:03:75:B6:D8:9E:FB:C3:ED:F0:7B:0F:30:59:8B:6E:2A:FF:AE"
    # settings.idp_cert_fingerprint_algorithm      = "http://www.w3.org/2000/09/xmldsig#sha1"
  end
end
