class TwoFactorAuthentication::Profile::TotpsController < ApplicationController
  before_action :set_user
  before_action :set_totp, only: %i[ new create ]

  def new
    @qr_code = RQRCode::QRCode.new(provisioning_uri)
  end

  def create
    if @totp.verify(params[:code], drift_behind: 15)
      @user.update! otp_required_for_sign_in: true
      redirect_to two_factor_authentication_profile_recovery_codes_path
    else
      redirect_to new_two_factor_authentication_profile_totp_path, alert: "That code didn't work. Please try again"
    end
  end

  def update
    @user.update! otp_secret: ROTP::Base32.random
    redirect_to new_two_factor_authentication_profile_totp_path
  end

  private
    def set_user
      @user = Current.user
    end

    def set_totp
      @totp = ROTP::TOTP.new(@user.otp_secret, issuer: "YourAppName")
    end

    def provisioning_uri
      @totp.provisioning_uri @user.email
    end
end
