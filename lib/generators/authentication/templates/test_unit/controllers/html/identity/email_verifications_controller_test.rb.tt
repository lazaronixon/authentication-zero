require "test_helper"

class Identity::EmailVerificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = sign_in_as(users(:lazaro_nixon))
    @user.update! verified: false
  end

  test "should send a verification email" do
    assert_enqueued_email_with UserMailer, :email_verification, args: { user: @user } do
      post identity_email_verification_url
    end

    assert_redirected_to root_url
  end

  test "should verify email" do
    sid = @user.email_verification_tokens.create.signed_id(expires_in: 2.days)

    get edit_identity_email_verification_url(sid: sid, email: @user.email)
    assert_redirected_to root_url
  end

  test "should not verify email with expired token" do
    sid_exp = @user.email_verification_tokens.create.signed_id(expires_in: 0.minutes)

    get edit_identity_email_verification_url(sid: sid_exp, email: @user.email)

    assert_redirected_to edit_identity_email_url
    assert_equal "That email verification link is invalid", flash[:alert]
  end
end
