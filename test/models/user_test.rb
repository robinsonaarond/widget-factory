require "test_helper"

class UserTest < ActiveSupport::TestCase
  USER_UUID = "f10242d0-e86a-4663-814b-5a1b111596bf"

  test "get_user" do
    u = User.get_user(USER_UUID)
    assert !u.nil?
  end

  test "get_office" do
    u = User.get_user(USER_UUID)
    o = User.get_office(u[:office][:office_uuid])
    assert !o.nil?
  end

  test "get_company" do
    u = User.get_user(USER_UUID)
    c = User.get_company(u[:company][:company_uuid])
    assert !c.nil?
  end

  test "get_board" do
    u = User.get_user(USER_UUID)
    b = User.get_board(u[:board][:board_uuid])
    assert !b.nil?
  end
end
