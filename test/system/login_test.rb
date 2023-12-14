require "application_system_test_case"

class LoginTest < ApplicationSystemTestCase
  test "admin logs in" do
    admin_user = admin_users(:admin_one)

    visit new_admin_user_session_path

    fill_in "Email", with: admin_user.email
    fill_in "Password", with: "password123"

    click_on "Login"

    assert_current_path admin_root_path
    assert_text "Dashboard"
  end
end
