require "rails/generators/active_record"

class AuthenticationGenerator < Rails::Generators::NamedBase
  include ActiveRecord::Generators::Migration

  class_option :api, type: :boolean, desc: "Generates API authentication"

  source_root File.expand_path("templates", __dir__)

  def create_controllers
    if options.api
      directory "controllers/api", "app/controllers"
    else
      directory "controllers/html", "app/controllers"
    end
  end

  def create_mailers
    template "mailers/password_mailer.rb", "app/mailers/password_mailer.rb"
  end

  def create_views
    if options.api
      directory "views/password_mailer", "app/views/password_mailer"
    else
      directory "views/html", "app/views"
    end
  end

  def create_models
    template "models/current.rb", "app/models/current.rb"
    template "models/resource.rb", "app/models/#{singular_table_name}.rb"
  end

  def create_migrations
    migration_template "migration.rb", "#{db_migrate_path}/create_#{file_name}.rb"
  end

  def add_routes
    route "get 'sign_up', to: 'registrations#new'" unless options.api?
    route "post 'sign_up', to: 'registrations#create'"
    route "get 'sign_in', to: 'sessions#new'" unless options.api?
    route "post 'sign_in', to: 'sessions#create'"
    route "get 'password/edit', to: 'passwords#edit'" unless options.api?
    route "patch 'password', to: 'passwords#update'"
    route "get 'cancellation/new', to: 'cancellations#new'" unless options.api?
    route "post 'cancellation', to: 'cancellations#destroy'"
    route "get 'password_reset/new', to: 'password_resets#new'" unless options.api?
    route "post 'password_reset', to: 'password_resets#create'"
    route "get 'password_reset/edit', to: 'password_resets#edit'"
    route "patch 'password_reset', to: 'password_resets#update'"
    route "delete 'sign_out', to: 'sessions#destroy'"
  end

  def add_application_controller_methods
    if options.api?
      inject_into_class "app/controllers/application_controller.rb", "ApplicationController", verbose: false do <<~CODE
        include ActionController::HttpAuthentication::Token::ControllerMethods

        before_action :authenticate

        private
          def authenticate
            if #{singular_table_name} = authenticate_with_http_token { |token, _| #{class_name}.find_by_session_token(token) }
              Current.user = #{singular_table_name}
            else
              request_http_token_authentication
            end
          end
      CODE
      end
    else
      inject_into_class "app/controllers/application_controller.rb", "ApplicationController", verbose: false do <<~CODE
        before_action :authenticate

        private
          def authenticate
            if #{singular_table_name} = cookies[:session_token] && #{class_name}.find_by_session_token(cookies[:session_token])
              Current.user = #{singular_table_name}
            else
              redirect_to sign_in_path, alert: "You need to sign in or sign up before continuing"
            end
          end
      CODE
      end
    end
  end
end
