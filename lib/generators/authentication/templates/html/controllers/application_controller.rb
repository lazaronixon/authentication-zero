class ApplicationController < ActionController::Base
  before_action :authenticate

  private
    def authenticate
      if user = cookies[:session_token] && User.find_by_session_token(cookies[:session_token])
        Current.user = user
      else
        redirect_to sign_in_path, alert: "You need to sign in or sign up before continuing"
      end
    end
end
