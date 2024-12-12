require "test_helper"

class Identity::EmailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user, @token = sign_in_as(users(:lazaro_nixon))
  end

  def default_headers
    { "Authorization" => "Bearer #{@token}" }
  end

  test "should update email" do
    patch identity_email_url, params: { email: "new_email@hey.com", password_challenge: "Secret1*3*5*" }, headers: default_headers
    assert_response :success
  end

  test "should not update email with wrong password challenge" do
    patch identity_email_url, params: { email: "new_email@hey.com", password_challenge: "SecretWrong1*3" }, headers: default_headers

    assert_response :unprocessable_entity
    assert_equal ["is invalid"], response.parsed_body["password_challenge"]
  end
end
