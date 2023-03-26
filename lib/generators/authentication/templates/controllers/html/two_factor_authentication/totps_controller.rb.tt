class TwoFactorAuthentication::TotpsController < ApplicationController
  before_action :set_user
  before_action :set_totp

  def new
    @qr_code = RQRCode::QRCode.new(@totp.provisioning_uri(@user.email))
  end

  def create
    if !@user.authenticate(params[:current_password])
      redirect_to new_two_factor_authentication_totp_path, alert: "The password you entered is incorrect"
    elsif @totp.verify(params[:code], drift_behind: 15)
      @user.update! otp_secret: params[:secret]
      redirect_to root_path, notice: "2FA is enabled on your account"
    else
      redirect_to new_two_factor_authentication_totp_path, alert: "That code didn't work. Please try again"
    end
  end

  def set_user
    @user = Current.user
  end

  def set_totp
    @totp = ROTP::TOTP.new(params[:secret] || ROTP::Base32.random, issuer: "YourAppName")
  end
end
