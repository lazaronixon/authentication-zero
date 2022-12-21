require "test_helper"

class SessionMailerTest < ActionMailer::TestCase
  setup do
    @session = users(:lazaro_nixon).sessions.create!
  end

  test "signed_in_notification" do
    mail = SessionMailer.with(session: @session).signed_in_notification
    assert_equal "New sign-in to your account", mail.subject
    assert_equal [@session.user.email], mail.to
  end
end
