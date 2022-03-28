class TwoFactorAuthentication::ChallengesController < ApplicationController
  skip_before_action :authenticate

  before_action :set_user

  def new
  end

  def create
    @totp = ROTP::TOTP.new(@user.otp_secret, issuer: "YourAppName")

    if @totp.verify(params[:code], drift_behind: 15)
      session = @user.sessions.create!
      cookies.signed.permanent[:session_token] = { value: session.id, httponly: true }

      redirect_to root_path, notice: "Signed in successfully"
    else
      redirect_to new_two_factor_authentication_challenge_path(token: params[:token]), alert: "That code didn't work. Please try again"
    end
  end

  private
    def set_user
      @user = User.find_signed!(params[:token], purpose: :authentication_challenge)
    rescue
      redirect_to sign_in_path, alert: "That's taking too long. Please re-enter your password and try again"
    end
end
