require "test_helper"

class Identity::EmailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user, @token = sign_in_as(users(:lazaro_nixon))
  end

  def default_headers
    { "Authorization" => "Bearer #{@token}" }
  end

  test "should update email" do
    patch identity_email_url, params: { email: "new_email@hey.com", current_password: "Secret1*3*5*" }, headers: default_headers
    assert_response :success
  end

  test "should not update email with wrong current password" do
    patch identity_email_url, params: { email: "new_email@hey.com", current_password: "SecretWrong1*3" }, headers: default_headers

    assert_response :bad_request
    assert_equal "The password you entered is incorrect", response.parsed_body["error"]
  end
end
