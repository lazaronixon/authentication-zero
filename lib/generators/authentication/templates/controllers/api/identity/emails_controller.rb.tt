class Identity::EmailsController < ApplicationController
  before_action :set_user

  def update
    if !@user.authenticate(params[:current_password])
      render json: { error: "The password you entered is incorrect" }, status: :bad_request
    elsif @user.update(email: params[:email])
      render_show
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
    def set_user
      @user = Current.user
    end

    def render_show
      if @user.email_previously_changed?
        resend_email_verification; render(json: @user)
      else
        render json: @user
      end
    end

    def resend_email_verification
      UserMailer.with(user: @user).email_verification.deliver_later
    end
end
