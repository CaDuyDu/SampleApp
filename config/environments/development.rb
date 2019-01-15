Rails.application.configure do

  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true

  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.seconds.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  config.action_mailer.raise_delivery_errors = true
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true
  config.assets.quiet = true
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
  config.action_mailer.delivery_method = :smtp
  host = "localhost:3000"
  config.action_mailer.default_url_options = {host: host}

  ActionMailer::Base.smtp_settings = {
    address: "smtp.gmail.com",
    port: "587",
    authentication: :plain,
    user_name: ENV["GMAIL_USERNAME"],
    password: ENV["GMAIL_PASSWORD"],
    enable_starttls_auto: true
  }

  config.middleware.use I18n::JS::Middleware
end
