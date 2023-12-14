require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
  driven_by :selenium, using: :headless_chrome

  def login_as_admin
    admin_user = admin_users(:admin_one)

    visit new_admin_user_session_path
    fill_in "Email", with: admin_user.email
    fill_in "Password", with: "password123"
    click_button "Login"
  end
end
