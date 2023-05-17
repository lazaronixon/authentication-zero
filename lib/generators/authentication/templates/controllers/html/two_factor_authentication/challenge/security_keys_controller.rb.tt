class TwoFactorAuthentication::Challenge::SecurityKeysController < ApplicationController
  skip_before_action :authenticate

  before_action :set_user

  def new
    respond_to do |format|
      format.html
      format.json { render json: options_for_get }
    end
  end

  def create
    if @user.security_keys.exists?(external_id: credential.id)
      sign_in_and_redirect_to_root
    else
      render json: { error: "Verification failed: #{e.message}" }, status: :unprocessable_entity
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

      render json: { status: "ok", location: root_url }, status: :created
    end

    def options_for_get
      WebAuthn::Credential.options_for_get(allow: external_ids)
    end

    def external_ids
      @user.security_keys.pluck(:external_id)
    end

    def credential
      @credential ||= WebAuthn::Credential.from_get(params.require(:credential))
    end
end
