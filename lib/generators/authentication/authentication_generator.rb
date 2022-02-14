require "rails/generators/active_record"

class AuthenticationGenerator < Rails::Generators::NamedBase
  include ActiveRecord::Generators::Migration

  source_root File.expand_path("templates", __dir__)

  def uncomment_bcrypt
    uncomment_lines 'Gemfile', /bcrypt/
  end

  def create_controllers
    directory "controllers/html", "app/controllers"
  end

  def create_mailers
    template "mailers/password_mailer.rb", "app/mailers/password_mailer.rb"
  end

  def create_views
    directory "views/html", "app/views"
  end

  def create_models
    template "models/current.rb", "app/models/current.rb"
    template "models/resource.rb", "app/models/#{singular_table_name}.rb"
  end

  def create_migrations
    migration_template "migration.rb", "#{db_migrate_path}/create_#{file_name}.rb"
  end

  def add_routes
    route "get 'sign_up', to: 'registrations#new'"
    route "post 'sign_up', to: 'registrations#create'"
    route "get 'sign_in', to: 'sessions#new'"
    route "post 'sign_in', to: 'sessions#create'"
    route "get 'password/edit', to: 'passwords#edit'"
    route "patch 'password', to: 'passwords#update'"
    route "get 'cancellation/new', to: 'cancellations#new'"
    route "post 'cancellation', to: 'cancellations#destroy'"
    route "get 'password_reset/new', to: 'password_resets#new'"
    route "post 'password_reset', to: 'password_resets#create'"
    route "get 'password_reset/edit', to: 'password_resets#edit'"
    route "patch 'password_reset', to: 'password_resets#update'"
    route "delete 'sign_out', to: 'sessions#destroy'"
  end

  def add_application_controller_methods
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
