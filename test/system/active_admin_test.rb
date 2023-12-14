require "application_system_test_case"

class ActiveAdminTest < ApplicationSystemTestCase
  setup do
    login_as_admin
  end

  test "visit dashboard" do
    visit admin_dashboard_url
    assert_selector "h2", text: "Dashboard"
  end

  test "visit admin users" do
    visit admin_admin_users_url
    assert_selector "h2", text: "Admin Users"
  end

  test "visit comments" do
    visit admin_comments_url
    assert_selector "h2", text: "Comments"
  end

  test "visit members" do
    visit admin_members_url
    assert_selector "h2", text: "Members"
  end

  test "visit settings" do
    visit admin_settings_url
    assert_selector "h2", text: "Settings"
  end

  test "visit transactions" do
    visit admin_transactions_url
    assert_selector "h2", text: "Transactions"
  end
end
