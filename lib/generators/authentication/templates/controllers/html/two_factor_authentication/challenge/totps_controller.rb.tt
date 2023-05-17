class TwoFactorAuthentication::Challenge::TotpsController < ApplicationController
  skip_before_action :authenticate

  before_action :set_user

  def new
  end

  def create
    @totp = ROTP::TOTP.new(@user.otp_secret, issuer: "YourAppName")

    if @totp.verify(params[:code], drift_behind: 15)
      sign_in_and_redirect_to_root
    else
      redirect_to new_two_factor_authentication_challenge_totp_path, alert: "That code didn't work. Please try again"
    end
  end

  private
    def set_user
      @user = User.find_signed!(session[:challenge_token], purpose: :authentication_challenge)
    rescue StandardError
      redirect_to sign_in_path, alert: "That's taking too long. Please re-enter your password and try again"
    end

    def sign_in_and_redirect_to_root
      session_record = @user.sessions.create!
      cookies.signed.permanent[:session_token] = { value: session_record.id, httponly: true }

      redirect_to root_path, notice: "Signed in successfully"
    end
end
