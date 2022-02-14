class SessionsController < ApplicationController
  skip_before_action :authenticate, except: :destroy

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_email(params[:email])

    if @user.try(:authenticate, params[:password])
      if params[:remember_me] == "1"
        cookies.permanent[:session_token] = { value: @user.session_token, httponly: true }
      else
        cookies[:session_token] = { value: @user.session_token, httponly: true }
      end

      redirect_to root_path, notice: "Signed in successfully"
    else
      redirect_to sign_in_path(email_hint: params[:email]), alert: "Invalid email or password"
    end
  end

  def destroy
    cookies.delete :session_token
    Current.user.regenerate_session_token
    redirect_to sign_in_path, notice: "Signed out successfully"
  end
end
