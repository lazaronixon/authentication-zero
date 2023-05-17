class MasqueradesController < ApplicationController
  before_action :authorize
  before_action :set_user

  def create
    session_record = @user.sessions.create!
    cookies.signed.permanent[:session_token] = { value: session_record.id, httponly: true }

    redirect_to root_path, notice: "Signed in successfully"
  end

  private
    def set_user
      @user = User.find(params[:user_id])
    end

    def authorize
      redirect_to(root_path, alert: "You must be in development") unless Rails.env.development?
    end
end
