Famtivity::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true
  config.cache_store = :dalli_store, '127.0.0.1:11211',  {:namespace => "famtivity", :compress  => true}
  config.identity_cache_store = :dalli_store

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

   #yui compressor
  #config.assets.js_compressor  = YUI::JavaScriptCompressor.new(munge: true) 
  config.assets.css_compressor = :yui
  config.assets.js_compressor = :uglifier

#  config.after_initialize do
#    Bullet.enable = true
#    Bullet.alert = true
#    Bullet.bullet_logger = true
#    Bullet.console = true
#    Bullet.rails_logger = true
#  end
  # Do not compress assets
  #config.assets.compress = true
  
  config.after_initialize do
    ActiveMerchant::Billing::Base.mode = :test
    ::GATEWAY = ActiveMerchant::Billing::AuthorizeNetGateway.new(
      :login => "3Rp74CQw2P",
      :password => "88Br2z8z6JuSY4QJ"
    )

    ::CIMGATEWAY = ActiveMerchant::Billing::AuthorizeNetCimGateway.new(
      :login => "3Rp74CQw2P",
      :password => "88Br2z8z6JuSY4QJ"
    )

    FB_APP_ID = '421335961251817'


  end

  # Expands the lines which load the assets
  config.assets.debug = true
  ActionMailer::Base.smtp_settings = {
    :enable_starttls_auto => true,  #this is the important shit!
    :address        => 'smtp.gmail.com',
    :port           => 587,
    :domain         => 'www.gmail.com',
    :authentication => :plain,
     :user_name      => 'no-reply@famtivity.com',
     :password       => 'F@mn0r3plY'
  }

  Paperclip.options[:command_path] = 'C:/PROGRA~1/IMAGEM~1.0-Q'
end
