require "test_helper"

class MemberTest < ActiveSupport::TestCase
  def setup
    @member = members(:one)
  end

  test "should not be valid without firstname" do
    @member.firstname = nil
    @member.valid?
    assert_not_empty @member.errors[:firstname], "No validation error for name present"
  end

  test "should not be valid without lastname" do
    @member.lastname = nil
    @member.valid?
    assert_not_empty @member.errors[:lastname], "No validation error for lastname present"
  end

  test "should not be valid without address" do
    @member.address = nil
    @member.valid?
    assert_not_empty @member.errors[:address], "No validation error for address present"
  end

  test "should not be valid without zip" do
    @member.zip = nil
    @member.valid?
    assert_not_empty @member.errors[:zip], "No validation error for zip present"
  end

  test "should not be valid without city" do
    @member.city = nil
    @member.valid?
    assert_not_empty @member.errors[:city], "No validation error for city present"
  end

  test "should not be valid without email" do
    @member.email = nil
    @member.valid?
    assert_not_empty @member.errors[:email], "No validation error for email present"
  end

  test "should not be valid without iban" do
    @member.iban = nil
    @member.valid?
    assert_not_empty @member.errors[:iban], "No validation error for iban present"
  end

  test "should not be valid without account_holder" do
    @member.account_holder = nil
    @member.valid?
    assert_not_empty @member.errors[:account_holder], "No validation error for account_holder present"
  end

  test "should not be valid without entry_date" do
    @member.entry_date = nil
    @member.valid?
    assert_not_empty @member.errors[:entry_date], "No validation error for entry_date present"
  end
end
