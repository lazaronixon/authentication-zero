class PasswordsController < ApplicationController
  before_action :set_user

  def update
    if !@user.authenticate(params[:current_password])
      render json: { error: "The current password you entered is incorrect" }, status: :bad_request
    elsif @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
    def set_user
      @user = Current.user
    end

    def user_params
      params.permit(:password, :password_confirmation)
    end
end
