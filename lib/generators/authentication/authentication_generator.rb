require "rails/generators/active_record"

class AuthenticationGenerator < Rails::Generators::NamedBase
  include ActiveRecord::Generators::Migration

  class_option :api,          type: :boolean, desc: "Generates API authentication"
  class_option :pwned,        type: :boolean, desc: "Add pwned password validation"
  class_option :lockable,     type: :boolean, desc: "Add password reset locking"
  class_option :ratelimit,    type: :boolean, desc: "Add request rate limiting"
  class_option :omniauthable, type: :boolean, desc: "Add social login support"

  source_root File.expand_path("templates", __dir__)

  def add_gems
    uncomment_lines "Gemfile", /"bcrypt"/
    uncomment_lines "Gemfile", /"redis"/  if options.lockable?
    uncomment_lines "Gemfile", /"kredis"/ if options.lockable?

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
  end

  def create_configuration_files
     copy_file "config/redis/shared.yml", "config/redis/shared.yml" if options.lockable?
     copy_file "config/initializers/omniauth.rb", "config/initializers/omniauth.rb" if omniauthable?
  end

  def add_environment_configurations
     ratelimit_code = <<~CODE
      # Rate limit general requests by IP address in a rate of 1000 requests per hour
      config.middleware.use(Rack::Ratelimit, name: "General", rate: [1000, 1.hour], redis: Redis.new, logger: Rails.logger) { |env| ActionDispatch::Request.new(env).ip }
    CODE

    environment ratelimit_code, env: "production" if options.ratelimit?
  end

  def create_migrations
    migration_template "migrations/create_table_migration.rb", "#{db_migrate_path}/create_#{table_name}.rb"
    migration_template "migrations/create_sessions_migration.rb", "#{db_migrate_path}/create_sessions.rb"
  end

  def create_models
    template "models/model.rb", "app/models/#{file_name}.rb"
    template "models/session.rb", "app/models/session.rb"
    template "models/current.rb", "app/models/current.rb"
    template "models/locking.rb", "app/models/locking.rb" if options.lockable?
  end

  def create_fixture_file
    template "test_unit/fixtures.yml", "test/fixtures/#{fixture_file_name}.yml"
  end

  def add_application_controller_methods
    api_code = <<~CODE
      include ActionController::HttpAuthentication::Token::ControllerMethods

      before_action :set_current_request_details
      before_action :authenticate

      def require_sudo
        if Current.session.sudo_at < 30.minutes.ago
          render json: { error: "Enter your password to continue" }, status: :forbidden
        end
      end

      private
        def authenticate
          if session = authenticate_with_http_token { |token, _| Session.find_signed(token) }
            Current.session = session
          else
            request_http_token_authentication
          end
        end

        def set_current_request_details
          Current.user_agent = request.user_agent
          Current.ip_address = request.ip
        end        
    CODE

    html_code = <<~CODE
      before_action :set_current_request_details
      before_action :authenticate

      def require_sudo
        if Current.session.sudo_at < 30.minutes.ago
          redirect_to new_sessions_sudo_path(proceed_to_url: request.url)
        end
      end

      private
        def authenticate
          if session = Session.find_by_id(cookies.signed[:session_token])
            Current.session = session
          else
            redirect_to sign_in_path
          end
        end

        def set_current_request_details
          Current.user_agent = request.user_agent
          Current.ip_address = request.ip
        end
    CODE

    inject_code = options.api? ? api_code : html_code
    inject_into_class "app/controllers/application_controller.rb", "ApplicationController", optimize_indentation(inject_code, 2), verbose: false
  end

  def create_controllers
    directory "controllers/#{format_folder}", "app/controllers"
    template  "controllers/omniauth_controller.rb", "app/controllers/sessions/omniauth_controller.rb" if omniauthable?
  end

  def create_views
    if options.api?
      directory "erb/identity_mailer", "app/views/identity_mailer"
      directory "erb/session_mailer", "app/views/session_mailer"
    else
      directory "erb", "app/views"
    end
  end

  def create_mailers
    directory "mailers", "app/mailers"
  end

  def add_routes
    if omniauthable?
      route "post '/auth/:provider/callback', to: 'sessions/omniauth#create'"
      route "get '/auth/:provider/callback', to: 'sessions/omniauth#create'"
      route "get '/auth/failure', to: 'sessions/omniauth#failure'"
    end

    route "resource :password_reset, only: [:new, :edit, :create, :update]", namespace: :identity
    route "resource :email_verification, only: [:edit, :create]", namespace: :identity
    route "resource :email, only: [:edit, :update]", namespace: :identity
    route "resource :sudo, only: [:new, :create]", namespace: :sessions
    route "resources :sessions, only: [:index, :show, :destroy]"
    route "resource :password, only: [:edit, :update]"
    route "post 'sign_up', to: 'registrations#create'"
    route "get 'sign_up', to: 'registrations#new'" unless options.api?
    route "post 'sign_in', to: 'sessions#create'"
    route "get 'sign_in', to: 'sessions#new'" unless options.api?
  end

  def create_test_files
    directory "test_unit/controllers/#{format_folder}", "test/controllers"
    directory "test_unit/system", "test/system" unless options.api?
  end

  private
    def format_folder
      options.api? ? "api" : "html"
    end

    def omniauthable?
      options.omniauthable? && !options.api?
    end
end
