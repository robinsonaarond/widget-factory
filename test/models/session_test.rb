require "test_helper"

class UserTest < ActiveSupport::TestCase
  USER_UUID = "f10242d0-e86a-4663-814b-5a1b111596bf"

  test "set_user_on_session" do
    u = User.get_user(USER_UUID)
    s = Session.set_user_on_session(u, {})

    assert s[:uuid] == USER_UUID
  end
end
