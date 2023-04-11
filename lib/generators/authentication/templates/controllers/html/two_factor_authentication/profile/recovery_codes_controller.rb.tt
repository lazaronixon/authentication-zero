class TwoFactorAuthentication::Profile::RecoveryCodesController < ApplicationController
  before_action :set_user

  def index
    if Current.user.recovery_codes.exists?
      @recovery_codes = @user.recovery_codes
    else
      @recovery_codes = @user.recovery_codes.create!(new_recovery_codes)
    end
  end

  def create
    @user.recovery_codes.delete_all
    @user.recovery_codes.create!(new_recovery_codes)

    redirect_to two_factor_authentication_profile_recovery_codes_path, notice: "Your new recovery codes have been generated"
  end

  private
    def set_user
      @user = Current.user
    end

    def new_recovery_codes
      10.times.map { { code: new_recovery_code } }
    end

    def new_recovery_code
      SecureRandom.alphanumeric(10).downcase
    end
end
