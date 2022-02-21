require "rails/generators/active_record"

class AuthenticationGenerator < Rails::Generators::NamedBase
  class_option :api, type: :boolean, desc: "Generates API authentication"

  class_option :migration, type: :boolean
  class_option :test_framework, type: :string, desc: "Test framework to be invoked"

  class_option :fixture, type: :boolean
  class_option :system_tests, type: :string, desc: "Skip system test files"

  class_option :skip_routes, type: :boolean
  class_option :template_engine, type: :string, desc: "Template engine to be invoked"

  source_root File.expand_path("templates", __dir__)

  def add_bcrypt
    uncomment_lines "Gemfile", /bcrypt/
  end

  def create_migration
    if options.migration
      invoke "migration", ["create_#{table_name}", "email:string:uniq", "password:digest", "session_token:string:uniq"]
    end
  end

  def create_model
    template "models/model.rb", "app/models/#{file_name}.rb"
    template "models/current.rb", "app/models/current.rb"
  end

  hook_for :fixture_replacement

  def create_fixture_file
    if options.fixture
      template "#{test_framework}/fixtures.yml", "test/fixtures/#{fixture_file_name}.yml"
    end
  end

  def add_application_controller_methods
    api_code = <<~CODE
      include ActionController::HttpAuthentication::Token::ControllerMethods

      before_action :authenticate

      private
        def authenticate
          authenticate_or_request_with_http_token do |token, _options|
            Current.#{singular_table_name} = #{class_name}.find_signed_session_token(token)
          end
        end
    CODE

    html_code = <<~CODE
      before_action :authenticate

      private
        def authenticate
          if #{singular_table_name} = #{class_name}.find_by_session_token(cookies.signed[:session_token])
            Current.#{singular_table_name} = #{singular_table_name}
          else
            redirect_to sign_in_path, alert: "You need to sign in or sign up before continuing"
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
      directory "#{template_engine}/email_mailer", "app/views/email_mailer"
      directory "#{template_engine}/password_mailer", "app/views/password_mailer"
    else
      directory "#{template_engine}", "app/views"
    end
  end

  def create_mailers
    template "mailers/email_mailer.rb", "app/mailers/email_mailer.rb"
    template "mailers/password_mailer.rb", "app/mailers/password_mailer.rb"
  end

  def add_routes
    unless options.skip_routes
      route "resource :password_resets, only: [:new, :edit, :create, :update]"
      route "resource :cancellations, only: [:new, :create]"
      route "resource :passwords, only: [:edit, :update]"
      route "resource :emails, only: [:edit, :update]"
      route "delete 'sign_out', to: 'sessions#destroy'"
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
