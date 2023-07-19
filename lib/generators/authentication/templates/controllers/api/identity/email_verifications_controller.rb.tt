class Identity::EmailVerificationsController < ApplicationController
  skip_before_action :authenticate, only: :show

  before_action :set_user, only: :show

  def show
    @user.update!(verified: true); head(:no_content)
  end

  def create
    UserMailer.with(user: Current.user).email_verification.deliver_later
  end

  private
    def set_user
      @user = User.find_by_token_for!(:email_verification, params[:sid])
    rescue StandardError
      render json: { error: "That email verification link is invalid" }, status: :bad_request
    end
end
