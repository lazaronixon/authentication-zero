require "test_helper"

class Identity::EmailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = sign_in_as(users(:lazaro_nixon))
  end

  test "should get edit" do
    get edit_identity_email_url
    assert_response :success
  end

  test "should update email" do
    patch identity_email_url, params: { email: "new_email@hey.com", password_challenge: "Secret1*3*5*" }
    assert_redirected_to root_url
  end


  test "should not update password with wrong password challenge" do
    patch password_url, params: { password_challenge: "SecretWrong1*3", password: "Secret6*4*2*", password_confirmation: "Secret6*4*2*" }

    assert_response :unprocessable_entity
    assert_select "li", /Password challenge is invalid/
  end
end
