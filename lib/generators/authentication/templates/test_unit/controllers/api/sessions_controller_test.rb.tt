require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user, @token = sign_in_as(users(:lazaro_nixon))
  end

  def default_headers
    { "Authorization" => "Bearer #{@token}" }
  end

  test "should get index" do
    get sessions_url, headers: default_headers
    assert_response :success
  end

  test "should show session" do
    get session_url(@user.sessions.last), headers: default_headers
    assert_response :success
  end

  test "should sign in" do
    post sign_in_url, params: { email: @user.email, password: "Secret1*3*5*" }
    assert_response :created
  end

  test "should not sign in with wrong credentials" do
    post sign_in_url, params: { email: @user.email, password: "SecretWrong1*3" }
    assert_response :unauthorized
  end

  test "should sign out" do
    delete session_url(@user.sessions.last), headers: default_headers
    assert_response :no_content
  end
end
