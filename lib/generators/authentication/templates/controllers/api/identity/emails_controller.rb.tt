class Identity::EmailsController < ApplicationController
  before_action :set_user

  def update
    if @user.update(user_params)
      render_show
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
    def set_user
      @user = Current.user
    end

    def user_params
      params.permit(:email, :password_challenge).with_defaults(password_challenge: "")
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
