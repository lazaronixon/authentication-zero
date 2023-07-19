require "application_system_test_case"

class Identity::EmailsTest < ApplicationSystemTestCase
  setup do
    @user = sign_in_as(users(:lazaro_nixon))
  end

  test "updating the email" do
    click_on "Change email address"

    fill_in "New email", with: "new_email@hey.com"
    fill_in "Password challenge", with: "Secret1*3*5*"
    click_on "Save changes"

    assert_text "Your email has been changed"
  end

  test "sending a verification email" do
    @user.update! verified: false

    click_on "Change email address"
    click_on "Re-send verification email"

    assert_text "We sent a verification email to your email address"
  end
end
