require "rails/generators/active_record"

class AuthenticationGenerator < Rails::Generators::Base
  include ActiveRecord::Generators::Migration

  class_option :api,              type: :boolean, desc: "Generates API authentication"
  class_option :pwned,            type: :boolean, desc: "Add pwned password validation"
  class_option :code_verifiable,  type: :boolean, desc: "Add email verification using a code for api"
  class_option :sudoable,         type: :boolean, desc: "Add password request before sensitive data changes"
  class_option :lockable,         type: :boolean, desc: "Add password reset locking"
  class_option :ratelimit,        type: :boolean, desc: "Add request rate limiting"
  class_option :omniauthable,     type: :boolean, desc: "Add social login support"
  class_option :trackable,        type: :boolean, desc: "Add activity log support"
  class_option :two_factor,       type: :boolean, desc: "Add two factor authentication"

  source_root File.expand_path("templates", __dir__)

  def add_gems
    uncomment_lines "Gemfile", /"bcrypt"/
    uncomment_lines "Gemfile", /"redis"/  if redis?
    uncomment_lines "Gemfile", /"kredis"/ if redis?

    if options.pwned?
      gem "pwned", comment: "Use Pwned to check if a password has been found in any of the huge data breaches [https://github.com/philnash/pwned]"
    end

    if options.ratelimit?
      gem "rack-ratelimit", group: :production, comment: "Use Rack::Ratelimit to rate limit requests [https://github.com/jeremy/rack-ratelimit]"
    end

    if omniauthable?
      gem "omniauth", comment: "Use OmniAuth to support multi-provider authentication [https://github.com/omniauth/omniauth]"
      gem "omniauth-rails_csrf_protection", comment: "Provides a mitigation against CVE-2015-9284 [https://github.com/cookpad/omniauth-rails_csrf_protection]"
    end

    if two_factor?
      gem "rotp", comment: "Use rotp for generating and validating one time passwords [https://github.com/mdp/rotp]"
      gem "rqrcode", comment: "Use rqrcode for creating and rendering QR codes into various formats [https://github.com/whomwah/rqrcode]"
    end
  end

  def create_configuration_files
    copy_file "config/redis/shared.yml", "config/redis/shared.yml" if redis?
    copy_file "config/initializers/omniauth.rb", "config/initializers/omniauth.rb" if omniauthable?
  end

  def add_environment_configurations
    ratelimit_code = <<~CODE
      # Rate limit general requests by IP address in a rate of 1000 requests per minute
      config.middleware.use(Rack::Ratelimit, name: "General", rate: [1000, 1.minute], redis: Redis.new, logger: Rails.logger) { |env| ActionDispatch::Request.new(env).ip }
    CODE

    environment ratelimit_code, env: "production" if options.ratelimit?
  end

  def create_migrations
    migration_template "migrations/create_users_migration.rb", "#{db_migrate_path}/create_users.rb"
    migration_template "migrations/create_sessions_migration.rb", "#{db_migrate_path}/create_sessions.rb"
    migration_template "migrations/create_events_migration.rb", "#{db_migrate_path}/create_events.rb" if options.trackable?
  end

  def create_models
    template "models/user.rb", "app/models/user.rb"
    template "models/session.rb", "app/models/session.rb"
    template "models/current.rb", "app/models/current.rb"
    template "models/event.rb", "app/models/event.rb" if options.trackable?
  end

  def create_fixture_file
    template "test_unit/users.yml", "test/fixtures/users.yml"
  end

  def create_controllers
    template  "controllers/#{format_folder}/application_controller.rb", "app/controllers/application_controller.rb", force: true

    directory "controllers/#{format_folder}/identity", "app/controllers/identity"
    directory "controllers/#{format_folder}/two_factor_authentication", "app/controllers/two_factor_authentication" if two_factor?
    template  "controllers/#{format_folder}/sessions_controller.rb", "app/controllers/sessions_controller.rb"
    template  "controllers/#{format_folder}/passwords_controller.rb", "app/controllers/passwords_controller.rb"
    template  "controllers/#{format_folder}/registrations_controller.rb", "app/controllers/registrations_controller.rb"
    template  "controllers/#{format_folder}/sessions/sudos_controller.rb", "app/controllers/sessions/sudos_controller.rb" if options.sudoable?
    template  "controllers/#{format_folder}/sessions/omniauth_controller.rb", "app/controllers/sessions/omniauth_controller.rb" if omniauthable?
    template  "controllers/#{format_folder}/authentications/events_controller.rb", "app/controllers/authentications/events_controller.rb" if options.trackable?
  end

  def create_views
    if options.api?
      directory "erb/user_mailer", "app/views/user_mailer"
      directory "erb/session_mailer", "app/views/session_mailer"
    else
      directory "erb/user_mailer", "app/views/user_mailer"
      directory "erb/session_mailer", "app/views/session_mailer"

      directory "erb/identity", "app/views/identity"
      directory "erb/passwords", "app/views/passwords"
      directory "erb/registrations", "app/views/registrations"

      template  "erb/sessions/index.html.erb", "app/views/sessions/index.html.erb"
      template  "erb/sessions/new.html.erb", "app/views/sessions/new.html.erb"

      directory "erb/sessions/sudos", "app/views/sessions/sudos" if options.sudoable?

      directory "erb/two_factor_authentication", "app/views/two_factor_authentication" if two_factor?
      directory "erb/authentications/events", "app/views/authentications/events" if options.trackable?
    end
  end

  def create_mailers
    directory "mailers", "app/mailers"
  end

  def add_routes
    if omniauthable?
      route "post '/auth/:provider/callback', to: 'sessions/omniauth#create'"
      route "get  '/auth/:provider/callback', to: 'sessions/omniauth#create'"
      route "get  '/auth/failure',            to: 'sessions/omniauth#failure'"
    end

    if two_factor?
      route "resource :totp,      only: [:new, :create]", namespace: :two_factor_authentication
      route "resource :challenge, only: [:new, :create]", namespace: :two_factor_authentication
    end

    if options.trackable?
      route "resources :events, only: :index", namespace: :authentications
    end

    route "resource :password_reset,     only: [:new, :edit, :create, :update]", namespace: :identity
    route "resource :email_verification, only: [:edit, :create]", namespace: :identity
    route "resource :email,              only: [:edit, :update]", namespace: :identity
    route "resource :sudo, only: [:new, :create]", namespace: :sessions if options.sudoable?
    route "resource  :password, only: [:edit, :update]"
    route "resources :sessions, only: [:index, :show, :destroy]"
    route "post 'sign_up', to: 'registrations#create'"
    route "get  'sign_up', to: 'registrations#new'" unless options.api?
    route "post 'sign_in', to: 'sessions#create'"
    route "get  'sign_in', to: 'sessions#new'" unless options.api?
  end

  def create_test_files
    directory "test_unit/controllers/#{format_folder}", "test/controllers"
    directory "test_unit/system", "test/system" unless options.api?
    template "test_unit/test_helper.rb", "test/test_helper.rb", force: true
    template "test_unit/application_system_test_case.rb", "test/application_system_test_case.rb", force: true unless options.api?
  end

  private
    def format_folder
      options.api? ? "api" : "html"
    end

    def omniauthable?
      options.omniauthable? && !options.api?
    end

    def two_factor?
      options.two_factor? && !options.api?
    end

    def code_verifiable?
      options.code_verifiable? && options.api?
    end

    def redis?
      options.lockable? || options.sudoable? || code_verifiable?
    end
end
