class SessionMailer < ApplicationMailer
  def signed_in_notification
    @session = params[:session]
    mail to: @session.user.email, subject: "New sign-in to your account"
  end
end
