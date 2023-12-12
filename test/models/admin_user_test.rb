require "test_helper"

class AdminUserTest < ActiveSupport::TestCase
  test "should save an admin user" do
    admin_user = AdminUser.new(email: "new_admin@example.com", password: "foobar", password_confirmation: "foobar")
    assert admin_user.save, "Did not save the admin user"
  end

  test "should not save admin user without email" do
    admin_user = AdminUser.new
    assert_not admin_user.save, "Saved the admin user without an email"
  end

  test "should not save admin user with mismatched password and confirmation" do
    admin_user = AdminUser.new(email: "new_admin@example.com", password: "foobar", password_confirmation: "barfoo")
    assert_not admin_user.save, "Saved the admin user with mismatched password and confirmation"
  end

  test "should have correct password" do
    admin_user = admin_users(:admin_one)
    assert admin_user.valid_password?("password123"), "Password is not correct"
  end

  test "should not save admin user with duplicate email" do
    admin_user = AdminUser.new(email: admin_users(:admin_one).email, password: "password123", password_confirmation: "password123")
    assert_not admin_user.save, "Saved the admin user with a duplicate email"
  end

  test "should not save admin user with invalid email format" do
    admin_user = AdminUser.new(email: "invalid_email", password: "password123", password_confirmation: "password123")
    assert_not admin_user.save, "Saved the admin user with an invalid email format"
  end
end
