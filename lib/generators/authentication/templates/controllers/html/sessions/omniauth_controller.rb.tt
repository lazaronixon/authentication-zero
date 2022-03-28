class Sessions::OmniauthController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate

  def create
    @user = User.where(omniauth_params).first_or_initialize(user_params)

    if @user.save
      session = @user.sessions.create!
      cookies.signed.permanent[:session_token] = { value: session.id, httponly: true }

      redirect_to root_path, notice: "Signed in successfully"
    else
      redirect_to sign_in_path, alert: "Authentication failed"
    end
  end

  def failure
    redirect_to sign_in_path, alert: params[:message]
  end

  private
    def omniauth_params
      { provider: omniauth.provider, uid: omniauth.uid }
    end

    def user_params
      { email: omniauth.info.email, password: SecureRandom::base58, verified: true }
    end

    def omniauth
      request.env["omniauth.auth"]
    end
end
