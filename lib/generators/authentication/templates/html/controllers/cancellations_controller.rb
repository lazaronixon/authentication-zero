class CancellationsController < ApplicationController
  def new
  end

  def destroy
    Current.user.destroy
    cookies.delete :session_token
    redirect_to sign_in_path, notice: "Bye! Your account has been successfully cancelled"
  end
end
