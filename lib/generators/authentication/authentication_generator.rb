require "rails/generators/active_record"

class AuthenticationGenerator < Rails::Generators::Base
  include ActiveRecord::Generators::Migration

  class_option :api,           type: :boolean, desc: "Generates API authentication"
  class_option :pwned,         type: :boolean, desc: "Add pwned password validation"
  class_option :sudoable,      type: :boolean, desc: "Add password request before sensitive data changes"
  class_option :lockable,      type: :boolean, desc: "Add password reset locking"
  class_option :ratelimit,     type: :boolean, desc: "Add request rate limiting"
  class_option :passwordless,  type: :boolean, desc: "Add passwordless sign"
  class_option :omniauthable,  type: :boolean, desc: "Add social login support"
  class_option :trackable,     type: :boolean, desc: "Add activity log support"
  class_option :two_factor,    type: :boolean, desc: "Add two factor authentication"
  class_option :webauthn,      type: :boolean, desc: "Add two factor authentication using a hardware security key"
  class_option :invitable,     type: :boolean, desc: "Add sending invitations"
  class_option :masqueradable, type: :boolean, desc: "Add sign-in as button functionallity"

  source_root File.expand_path("templates", __dir__)

  def add_gems
    gem "bcrypt", "~> 3.1.7", comment: "Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]"

    if options.ratelimit?
      gem "rack-ratelimit", group: :production, comment: "Use Rack::Ratelimit to rate limit requests [https://github.com/jeremy/rack-ratelimit]"
    end

    if redis?
      gem "redis", "~> 4.0", comment: "Use Redis adapter to run additional authentication features"
      gem "kredis", comment: "Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]"
    end

    if options.pwned?
      gem "pwned", comment: "Use Pwned to check if a password has been found in any of the huge data breaches [https://github.com/philnash/pwned]"
    end

    if omniauthable?
      gem "omniauth", comment: "Use OmniAuth to support multi-provider authentication [https://github.com/omniauth/omniauth]"
      gem "omniauth-rails_csrf_protection", comment: "Provides a mitigation against CVE-2015-9284 [https://github.com/cookpad/omniauth-rails_csrf_protection]"
    end

    if two_factor?
      gem "rotp", comment: "Use rotp for generating and validating one time passwords [https://github.com/mdp/rotp]"
      gem "rqrcode", comment: "Use rqrcode for creating and rendering QR codes into various formats [https://github.com/whomwah/rqrcode]"
    end

    if webauthn?
      gem "webauthn", comment: "Use webauthn for making rails become a conformant web authn relying party [https://github.com/cedarcode/webauthn-ruby]"
    end
  end

  def add_environment_configurations
    application "config.action_mailer.default_url_options = { host: \"localhost\", port: 3000 }", env: "development"
    application "config.action_mailer.default_url_options = { host: \"localhost\", port: 3000 }", env: "test"
    environment ratelimit_block, env: "production" if options.ratelimit?
  end

  def create_configuration_files
    copy_file "config/redis/shared.yml", "config/redis/shared.yml" if redis?
    copy_file "config/initializers/omniauth.rb", "config/initializers/omniauth.rb" if omniauthable?
    copy_file "config/initializers/webauthn.rb", "config/initializers/webauthn.rb" if webauthn?
  end

  def create_migrations
    migration_template "migrations/create_email_verification_tokens_migration.rb", "#{db_migrate_path}/create_email_verification_tokens.rb"
    migration_template "migrations/create_events_migration.rb", "#{db_migrate_path}/create_events.rb" if options.trackable?
    migration_template "migrations/create_password_reset_tokens_migration.rb", "#{db_migrate_path}/create_password_reset_tokens.rb"
    migration_template "migrations/create_recovery_codes_migration.rb", "#{db_migrate_path}/create_recovery_codes.rb" if two_factor?
    migration_template "migrations/create_security_keys_migration.rb", "#{db_migrate_path}/create_security_keys.rb" if webauthn?
    migration_template "migrations/create_sessions_migration.rb", "#{db_migrate_path}/create_sessions.rb"
    migration_template "migrations/create_sign_in_tokens_migration.rb", "#{db_migrate_path}/create_sign_in_tokens_migration.rb" if passwordless?
    migration_template "migrations/create_users_migration.rb", "#{db_migrate_path}/create_users.rb"
  end

  def create_models
    template "models/current.rb", "app/models/current.rb"
    template "models/email_verification_token.rb", "app/models/email_verification_token.rb"
    template "models/event.rb", "app/models/event.rb" if options.trackable?
    template "models/password_reset_token.rb", "app/models/password_reset_token.rb"
    template "models/recovery_code.rb", "app/models/recovery_code.rb" if two_factor?
    template "models/security_key.rb", "app/models/security_key.rb" if webauthn?
    template "models/session.rb", "app/models/session.rb"
    template "models/sign_in_token.rb", "app/models/sign_in_token.rb" if passwordless?
    template "models/user.rb", "app/models/user.rb"
  end

  def create_fixture_file
    copy_file "test_unit/users.yml", "test/fixtures/users.yml"
  end

  def create_controllers
    template "controllers/#{format}/authentications/events_controller.rb", "app/controllers/authentications/events_controller.rb" if options.trackable?

    directory "controllers/#{format}/identity", "app/controllers/identity"

    template "controllers/#{format}/sessions/omniauth_controller.rb", "app/controllers/sessions/omniauth_controller.rb" if omniauthable?
    template "controllers/#{format}/sessions/passwordlesses_controller.rb", "app/controllers/sessions/passwordlesses_controller.rb" if passwordless?
    template "controllers/#{format}/sessions/sudos_controller.rb", "app/controllers/sessions/sudos_controller.rb" if sudoable?

    if two_factor?
      template "controllers/html/two_factor_authentication/challenge/recovery_codes_controller.rb", "app/controllers/two_factor_authentication/challenge/recovery_codes_controller.rb"
      template "controllers/html/two_factor_authentication/challenge/security_keys_controller.rb", "app/controllers/two_factor_authentication/challenge/security_keys_controller.rb" if webauthn?
      template "controllers/html/two_factor_authentication/challenge/totps_controller.rb", "app/controllers/two_factor_authentication/challenge/totps_controller.rb"

      template "controllers/html/two_factor_authentication/profile/recovery_codes_controller.rb", "app/controllers/two_factor_authentication/profile/recovery_codes_controller.rb"
      template "controllers/html/two_factor_authentication/profile/security_keys_controller.rb", "app/controllers/two_factor_authentication/profile/security_keys_controller.rb" if webauthn?
      template "controllers/html/two_factor_authentication/profile/totps_controller.rb", "app/controllers/two_factor_authentication/profile/totps_controller.rb"
    end

    template "controllers/#{format}/application_controller.rb", "app/controllers/application_controller.rb", force: true
    template "controllers/#{format}/home_controller.rb", "app/controllers/home_controller.rb" unless options.api?
    template "controllers/#{format}/invitations_controller.rb", "app/controllers/invitations_controller.rb" if invitable?
    template "controllers/#{format}/masquerades_controller.rb", "app/controllers/masquerades_controller.rb" if masqueradable?
    template "controllers/#{format}/passwords_controller.rb", "app/controllers/passwords_controller.rb"
    template "controllers/#{format}/registrations_controller.rb", "app/controllers/registrations_controller.rb"
    template "controllers/#{format}/sessions_controller.rb", "app/controllers/sessions_controller.rb"
  end

  def install_javascript
    return unless webauthn?
    copy_file "javascript/controllers/application.js", "app/javascript/controllers/application.js", force: true
    run "bin/importmap pin stimulus-web-authn" if importmaps?
    run "yarn add stimulus-web-authn" if node?
  end

  def create_views
    if options.api?
      template "erb/user_mailer/email_verification.html.erb", "app/views/user_mailer/email_verification.html.erb"
      template "erb/user_mailer/password_reset.html.erb", "app/views/user_mailer/password_reset.html.erb"
    else
      directory "erb/authentications/events", "app/views/authentications/events" if options.trackable?
      directory "erb/home", "app/views/home"
      directory "erb/identity", "app/views/identity"
      directory "erb/invitations", "app/views/invitations" if invitable?
      directory "erb/passwords", "app/views/passwords"
      directory "erb/registrations", "app/views/registrations"

      directory "erb/sessions/passwordlesses", "app/views/sessions/passwordlesses" if passwordless?
      directory "erb/sessions/sudos", "app/views/sessions/sudos" if sudoable?
      template  "erb/sessions/index.html.erb", "app/views/sessions/index.html.erb"
      template  "erb/sessions/new.html.erb", "app/views/sessions/new.html.erb"

      if two_factor?
        directory "erb/two_factor_authentication/challenge/recovery_codes", "app/views/two_factor_authentication/challenge/recovery_codes"
        directory "erb/two_factor_authentication/challenge/security_keys", "app/views/two_factor_authentication/challenge/security_keys" if webauthn?
        directory "erb/two_factor_authentication/challenge/totps", "app/views/two_factor_authentication/challenge/totps"

        directory "erb/two_factor_authentication/profile/recovery_codes", "app/views/two_factor_authentication/profile/recovery_codes"
        directory "erb/two_factor_authentication/profile/security_keys", "app/views/two_factor_authentication/profile/security_keys" if webauthn?
        directory "erb/two_factor_authentication/profile/totps", "app/views/two_factor_authentication/profile/totps"
      end

      template "erb/user_mailer/email_verification.html.erb", "app/views/user_mailer/email_verification.html.erb"
      template "erb/user_mailer/invitation_instructions.html.erb", "app/views/user_mailer/invitation_instructions.html.erb" if invitable?
      template "erb/user_mailer/password_reset.html.erb", "app/views/user_mailer/password_reset.html.erb"
      template "erb/user_mailer/passwordless.html.erb", "app/views/user_mailer/passwordless.html.erb" if passwordless?
    end
  end

  def create_mailers
    directory "mailers", "app/mailers"
  end

  def add_routes
    route 'root "home#index"' unless options.api?

    if sudoable?
      route "resource :sudo, only: [:new, :create]", namespace: :sessions
    end

    if invitable?
      route "resource :invitation, only: [:new, :create]"
    end

    if passwordless?
      route "resource :passwordless, only: [:new, :edit, :create]", namespace: :sessions
    end

    if masqueradable?
      route 'post "users/:user_id/masquerade", to: "masquerades#create", as: :user_masquerade'
    end

    if omniauthable?
      route 'post "/auth/:provider/callback", to: "sessions/omniauth#create"'
      route 'get  "/auth/:provider/callback", to: "sessions/omniauth#create"'
      route 'get  "/auth/failure",            to: "sessions/omniauth#failure"'
    end

    if two_factor?
      route "resources :recovery_codes, only: [:index, :create]", namespace: [:two_factor_authentication, :profile]
      route "resource  :totp,           only: [:new, :create, :update]", namespace: [:two_factor_authentication, :profile]
      route "resources :security_keys", namespace: [:two_factor_authentication, :profile] if webauthn?

      route "resource :recovery_codes, only: [:new, :create]", namespace: [:two_factor_authentication, :challenge]
      route "resource :totp,           only: [:new, :create]", namespace: [:two_factor_authentication, :challenge]
      route "resource :security_keys,  only: [:new, :create]", namespace: [:two_factor_authentication, :challenge] if webauthn?
    end

    if options.trackable?
      route "resources :events, only: :index", namespace: :authentications
    end

    route "resource :password_reset,     only: [:new, :edit, :create, :update]", namespace: :identity
    route "resource :email_verification, only: [:show, :create]", namespace: :identity
    route "resource :email,              only: [:edit, :update]", namespace: :identity

    route "resource  :password, only: [:edit, :update]"
    route "resources :sessions, only: [:index, :show, :destroy]"

    route 'post "sign_up", to: "registrations#create"'
    route 'get  "sign_up", to: "registrations#new"' unless options.api?

    route 'post "sign_in", to: "sessions#create"'
    route 'get  "sign_in", to: "sessions#new"' unless options.api?
  end

  def create_test_files
    directory "test_unit/controllers/#{format}", "test/controllers"
    directory "test_unit/mailers/", "test/mailers"
    directory "test_unit/system", "test/system" unless options.api?
    template "test_unit/test_helper.rb", "test/test_helper.rb", force: true
    template "test_unit/application_system_test_case.rb", "test/application_system_test_case.rb", force: true unless options.api?
  end

  private
    def format
      options.api? ? "api" : "html"
    end

    def omniauthable?
      options.omniauthable? && !options.api?
    end

    def passwordless?
      options.passwordless? && !options.api?
    end

    def two_factor?
      options.two_factor? && !options.api?
    end

    def webauthn?
      options.webauthn? && two_factor?
    end

    def invitable?
      options.invitable? && !options.api?
    end

    def masqueradable?
      options.masqueradable? && !options.api?
    end

    def sudoable?
      options.sudoable? && !options.api?
    end

    def redis?
      options.lockable? || options.ratelimit? || sudoable?
    end

    def importmaps?
      Rails.root.join("config/importmap.rb").exist?
    end

    def node?
      Rails.root.join("package.json").exist?
    end

    def ratelimit_block
      <<~CODE
        # Rate limit general requests by IP address in a rate of 1000 requests per minute
        config.middleware.use(Rack::Ratelimit, name: "General", rate: [1000, 1.minute], redis: Redis.new, logger: Rails.logger) { |env| ActionDispatch::Request.new(env).ip }
      CODE
    end
end
