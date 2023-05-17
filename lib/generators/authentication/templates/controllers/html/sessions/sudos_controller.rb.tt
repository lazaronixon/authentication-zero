class Sessions::SudosController < ApplicationController
  def new
  end

  def create
    session_record = Current.session

    if session_record.user.authenticate(params[:password])
      session_record.sudo.mark; redirect_to(params[:proceed_to_url])
    else
      redirect_to new_sessions_sudo_path(proceed_to_url: params[:proceed_to_url]), alert: "The password you entered is incorrect"
    end
  end
end
