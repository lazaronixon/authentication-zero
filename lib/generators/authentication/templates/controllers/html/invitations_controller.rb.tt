class InvitationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.create_with(user_params).find_or_initialize_by(email: params[:email])

    if @user.save
      send_invitation_instructions
      redirect_to new_invitation_path, notice: "An invitation email has been sent to #{@user.email}"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.permit(:email).merge(password: SecureRandom.base58, verified: true)
    end

    def send_invitation_instructions
      UserMailer.with(user: @user).invitation_instructions.deliver_later
    end
end
