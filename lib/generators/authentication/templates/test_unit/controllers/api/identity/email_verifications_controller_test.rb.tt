require "test_helper"

class Identity::EmailVerificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user, @token = sign_in_as(users(:lazaro_nixon))
    @sid = @user.signed_id(purpose: "email_verification/#{@user.email}", expires_in: 20.minutes)
    @sid_exp = @user.signed_id(purpose: "email_verification/#{@user.email}", expires_in: 0.minutes)

    @user.update! verified: false
  end

  def default_headers
    { "Authorization" => "Bearer #{@token}" }
  end

  test "should send a verification email" do
    assert_enqueued_email_with UserMailer, :email_verification, args: { user: @user } do
      post identity_email_verification_url, headers: default_headers
    end

    assert_response :no_content
  end

  test "should verify email" do
    get edit_identity_email_verification_url, params: { token: @sid, email: @user.email }, headers: default_headers
    assert_response :no_content
  end

  test "should not verify email with expired token" do
    get edit_identity_email_verification_url, params: { token: @sid_exp, email: @user.email }, headers: default_headers

    assert_response :bad_request
    assert_equal "That email verification link is invalid", response.parsed_body["error"]
  end

  test "should not verify email with previous token" do
    @user.update! email: "other_email@hey.com"

    get edit_identity_email_verification_url, params: { token: @sid, email: @user.email_previously_was }, headers: default_headers

    assert_response :bad_request
    assert_equal "That email verification link is invalid", response.parsed_body["error"]
  end
end
