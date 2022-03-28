require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user, @token = sign_in_as(users(:lazaro_nixon))
  end

  def default_headers
    { "Authorization" => "Bearer #{@token}" }
  end

  test "should update password" do
    patch password_url, params: { current_password: "Secret1*3*5*", password: "Secret6*4*2*", password_confirmation: "Secret6*4*2*" }, headers: default_headers
    assert_response :success
  end

  test "should not update password with wrong current password" do
    patch password_url, params: { current_password: "SecretWrong1*3", password: "Secret6*4*2*", password_confirmation: "Secret6*4*2*" }, headers: default_headers

    assert_response :bad_request
    assert_equal "The current password you entered is incorrect", response.parsed_body["error"]
  end
end
