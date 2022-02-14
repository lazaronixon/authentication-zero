class PasswordResetsController < ApplicationController
  before_action :set_user, only: %i[ edit update ]
  skip_before_action :authenticate

  def new
  end

  def edit
  end

  def create
    if @user = User.find_by_email(params[:email])
      PasswordMailer.with(user: @user).reset.deliver_later
      redirect_to sign_in_path, notice: "You will receive an email with instructions on how to reset your password in a few minutes"
    else
      redirect_to password_reset_new_path, alert: "The email address doesn't exist in our database"
    end
  end

  def update
    if @user.update(password_params)
      redirect_to sign_in_path, notice: "Your password was reset successfully. Please sign in"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_user
      @user = User.find_signed!(params[:token], purpose: "password_reset")
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to sign_in_path, alert: "Your token has expired, please request a new one"
    end

    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end
end
