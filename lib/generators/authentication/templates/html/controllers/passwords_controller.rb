class PasswordsController < ApplicationController
  def edit
    @user = Current.user
  end

  def update
    if !Current.user.authenticate(params[:current_password])
      redirect_to password_edit_path, alert: "The current password you entered is incorrect"
    elsif Current.user.update(password_params)
      redirect_to root_path, notice: "Your password has been changed successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end
end
