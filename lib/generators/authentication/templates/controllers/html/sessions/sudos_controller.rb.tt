class Sessions::SudosController < ApplicationController
  def new
  end

  def create
    session = Current.session

    if session.user.authenticate(params[:password])
      session.sudo.mark; redirect_to(params[:proceed_to_url])
    else
      redirect_to new_sessions_sudo_path(proceed_to_url: params[:proceed_to_url]), alert: "The password you entered is incorrect"
    end
  end
end
