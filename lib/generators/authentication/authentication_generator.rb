require "rails/generators/active_record"

class AuthenticationGenerator < Rails::Generators::NamedBase
  include ActiveRecord::Generators::Migration

  class_option :api, type: :boolean, desc: "Generates API authentication"

  class_option :migration, type: :boolean, default: true
  class_option :test_framework, type: :string, desc: "Test framework to be invoked"

  class_option :fixture, type: :boolean, default: true
  class_option :system_tests, type: :string, desc: "Skip system test files"

  class_option :skip_routes, type: :boolean
  class_option :template_engine, type: :string, desc: "Template engine to be invoked"

  source_root File.expand_path("templates", __dir__)

  def add_bcrypt
    uncomment_lines "Gemfile", /bcrypt/
  end

  def create_migrations
    if options.migration
      migration_template "migrations/create_table_migration.rb", "#{db_migrate_path}/create_#{table_name}.rb"
      migration_template "migrations/create_sessions_migration.rb", "#{db_migrate_path}/create_sessions.rb"
    end
  end

  def create_models
    template "models/model.rb", "app/models/#{file_name}.rb"
    template "models/session.rb", "app/models/session.rb"
    template "models/current.rb", "app/models/current.rb"
  end

  hook_for :fixture_replacement

  def create_fixture_file
    if options.fixture && options.fixture_replacement.nil?
      template "#{test_framework}/fixtures.yml", "test/fixtures/#{fixture_file_name}.yml"
    end
  end

  def add_application_controller_methods
    api_code = <<~CODE
      include ActionController::HttpAuthentication::Token::ControllerMethods

      before_action :authenticate

      private
        def authenticate
          if session = authenticate_with_http_token { |token, _| Session.find_signed(token) }
            Current.session = session
          else
            request_http_token_authentication
          end
        end
    CODE

    html_code = <<~CODE
      before_action :authenticate

      private
        def authenticate
          if session = Session.find_by_id(cookies.signed[:session_token])
            Current.session = session
          else
            redirect_to sign_in_path
          end
        end
    CODE

    inject_code = options.api? ? api_code : html_code
    inject_into_class "app/controllers/application_controller.rb", "ApplicationController", optimize_indentation(inject_code, 2), verbose: false
  end

  def create_controllers
    directory "controllers/#{format_folder}", "app/controllers"
  end

  def create_views
    if options.api
      directory "erb/identity_mailer", "app/views/identity_mailer"
      directory "erb/session_mailer", "app/views/session_mailer"
    else
      directory "#{template_engine}", "app/views"
    end
  end

  def create_mailers
    directory "mailers", "app/mailers"
  end

  def add_routes
    unless options.skip_routes
      route "resource :registration, only: :destroy"
      route "resource :password_reset, only: [:new, :edit, :create, :update]"
      route "resource :password, only: [:edit, :update]"
      route "resource :email_verification, only: [:edit, :create]"
      route "resource :email, only: [:edit, :update]"
      route "resources :sessions, only: [:index, :show, :destroy]"
      route "post 'sign_up', to: 'registrations#create'"
      route "get 'sign_up', to: 'registrations#new'" unless options.api?
      route "post 'sign_in', to: 'sessions#create'"
      route "get 'sign_in', to: 'sessions#new'" unless options.api?
    end
  end

  def create_test_files
    directory "#{test_framework}/controllers/#{format_folder}", "test/controllers"
    directory "#{system_tests}/system", "test/system" if system_tests?
  end

  private
    def format_folder
      options.api ? "api" : "html"
    end

    def template_engine
      options.template_engine
    end

    def test_framework
      options.test_framework
    end

    def system_tests
      options.system_tests
    end

    def system_tests?
      !options.api? && options.system_tests
    end
end
