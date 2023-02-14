class Identity::EmailsController < ApplicationController
  before_action :set_user

  def edit
  end

  def update
   if !@user.authenticate(params[:current_password])
      redirect_to edit_identity_email_path, alert: "The password you entered is incorrect"
    elsif @user.update(user_params)
      redirect_to_root
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_user
      @user = Current.user
    end

    def user_params
      params.permit(:email)
    end

    def redirect_to_root
      if @user.email_previously_changed?
        resend_email_verification
        redirect_to root_path, notice: "Your email has been changed"
      else
        redirect_to root_path
      end
    end

    def resend_email_verification
      UserMailer.with(user: @user).email_verification.deliver_later
    end
end
