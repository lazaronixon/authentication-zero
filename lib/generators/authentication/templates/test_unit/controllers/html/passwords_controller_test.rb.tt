require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = sign_in_as(users(:lazaro_nixon))
  end

  test "should get edit" do
    get edit_password_url
    assert_response :success
  end

  test "should update password" do
    patch password_url, params: { current_password: "Secret1*3*5*", password: "Secret6*4*2*", password_confirmation: "Secret6*4*2*" }
    assert_redirected_to root_url
  end

  test "should not update password with wrong current password" do
    patch password_url, params: { current_password: "SecretWrong1*3", password: "Secret6*4*2*", password_confirmation: "Secret6*4*2*" }

    assert_redirected_to edit_password_url
    assert_equal "The current password you entered is incorrect", flash[:alert]
  end
end
