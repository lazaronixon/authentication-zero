require "test_helper"

class Identity::EmailVerificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user, @token = sign_in_as(users(:lazaro_nixon))
    @user.update! verified: false
  end

  def default_headers
    { "Authorization" => "Bearer #{@token}" }
  end

  test "should send a verification email" do
    assert_enqueued_email_with UserMailer, :email_verification, params: { user: @user } do
      post identity_email_verification_url, headers: default_headers
    end

    assert_response :no_content
  end

  test "should verify email" do
    sid = @user.generate_token_for(:email_verification)

    get identity_email_verification_url, params: { sid: sid }, headers: default_headers
    assert_response :no_content
  end

  test "should not verify email with expired token" do
    sid = @user.generate_token_for(:email_verification)

    travel 3.days

    get identity_email_verification_url, params: { sid: sid }, headers: default_headers

    assert_response :bad_request
    assert_equal "That email verification link is invalid", response.parsed_body["error"]
  end
end
