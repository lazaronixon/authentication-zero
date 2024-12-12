require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user, @token = sign_in_as(users(:lazaro_nixon))
  end

  def default_headers
    { "Authorization" => "Bearer #{@token}" }
  end

  test "should update password" do
    patch password_url, params: { password_challenge: "Secret1*3*5*", password: "Secret6*4*2*", password_confirmation: "Secret6*4*2*" }, headers: default_headers
    assert_response :success
  end

  test "should not update password with wrong password challenge" do
    patch password_url, params: { password_challenge: "SecretWrong1*3", password: "Secret6*4*2*", password_confirmation: "Secret6*4*2*" }, headers: default_headers

    assert_response :unprocessable_entity
    assert_equal ["is invalid"], response.parsed_body["password_challenge"]
  end
end
