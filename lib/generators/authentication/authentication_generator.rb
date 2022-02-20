require "rails/generators/active_record"

class AuthenticationGenerator < Rails::Generators::NamedBase
  include ActiveRecord::Generators::Migration

  class_option :api, type: :boolean, desc: "Generates API authentication"

  source_root File.expand_path("templates", __dir__)

  def create_migrations
    invoke "migration", ["create_#{table_name}", "email:string:uniq", "password_digest:string", "session_token:string:uniq"]
  end

  def create_models
    template "app/models/model.rb", "app/models/#{file_name}.rb"
    template "app/models/current.rb", "app/models/current.rb"
  end

  def create_controllers
    directory "app/controllers/#{format_folder}", "app/controllers"
  end

  def create_views
    if options.api
      directory "app/views/email_mailer", "app/views/email_mailer"
      directory "app/views/password_mailer", "app/views/password_mailer"
    else
      directory "app/views", "app/views"
    end
  end

  def create_mailers
    template "app/mailers/email_mailer.rb", "app/mailers/email_mailer.rb"
    template "app/mailers/password_mailer.rb", "app/mailers/password_mailer.rb"
  end

  def add_routes
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

  def add_application_controller_methods
    if options.api?
      inject_into_class "app/controllers/application_controller.rb", "ApplicationController", verbose: false do <<-CODE
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate

  private
    def authenticate
      authenticate_or_request_with_http_token do |token, _options|
        Current.#{singular_table_name} = #{class_name}.find_signed_session_token(token)
      end
    end
      CODE
      end
    else
      inject_into_class "app/controllers/application_controller.rb", "ApplicationController", verbose: false do <<-CODE
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
      end
    end
  end

  def create_fixture_file
    template "test/fixtures.yml", "test/fixtures/#{fixture_file_name}.yml"
  end

  def create_test_controllers
    directory "test/controllers/#{format_folder}", "test/controllers"
  end

  private
    def format_folder
      options.api ? "api" : "html"
    end
end
