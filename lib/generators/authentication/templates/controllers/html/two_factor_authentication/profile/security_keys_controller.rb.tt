class TwoFactorAuthentication::Profile::SecurityKeysController < ApplicationController
  before_action :set_user
  before_action :set_security_key, only: %i[ edit update destroy ]

  def index
    @security_keys = @user.security_keys
  end

  def new
    respond_to do |format|
      format.html
      format.json { render json: options_for_create }
    end
  end

  def edit
  end

  def create
    @security_key = @user.security_keys.create!(credential_params)
    render json: { status: "ok", location: edit_two_factor_authentication_profile_security_key_url(@security_key, confirmation: true) }, status: :created
  end

  def update
    @security_key.update! name: params[:name]
    redirect_to two_factor_authentication_profile_security_keys_path, notice: "Your changes have been saved"
  end

  def destroy
    @security_key.destroy
    redirect_to two_factor_authentication_profile_security_keys_path, notice: "#{@security_key.name} has been removed"
  end

  private
    def set_user
      @user = Current.user
    end

    def set_security_key
      @security_key = @user.security_keys.find(params[:id])
    end

    def options_for_create
      WebAuthn::Credential.options_for_create(user: user_info, exclude: external_ids)
    end

    def user_info
      { id: @user.webauthn_id, name: @user.email }
    end

    def external_ids
      @user.security_keys.pluck(:external_id)
    end

    def credential_params
      { external_id: credential.id, name: "security key" }
    end

    def credential
      @credential ||= WebAuthn::Credential.from_create(params.require(:credential))
    end
end
