require "test_helper"

class RegistrationFormTest < ActiveSupport::TestCase
  def setup
    @form = RegistrationForm.new(
      email: "test@example.com",
      firstname: "John",
      lastname: "Doe",
      address: "123 Main St",
      zip: "12345",
      city: "City",
      annual_fee: 100,
      iban: "DE89370400440532013000",
      account_holder: "John Doe",
      terms: true,
      sepa_mandate: true
    )
  end

  test "valid form should save a new member" do
    assert_difference "Member.count", 1 do
      assert @form.save
    end
  end

  test "invalid form should not save a new member" do
    @form.firstname = nil
    assert_no_difference "Member.count" do
      assert_not @form.save
    end
  end

  test "form should have presence validation" do
    @form.firstname = nil
    assert_not @form.valid?
    assert_equal ["muss ausgefüllt werden"], @form.errors[:firstname]
  end

  test "form should have iban validation" do
    @form.iban = "invalid"
    assert_not @form.valid?
    assert_equal ["ist keine gültige IBAN"], @form.errors[:iban]
  end

  test "form should have numericality validation" do
    @form.annual_fee = 10
    assert_not @form.valid?
    assert_equal ["muss größer oder gleich 15 sein"], @form.errors[:annual_fee]
  end

  test "form should have length validation" do
    @form.account_holder = "a" * 71
    assert_not @form.valid?
    assert_equal ["ist zu lang (mehr als 70 Zeichen)"], @form.errors[:account_holder]
  end

  test "form should have acceptance validation for terms" do
    @form.terms = false
    assert_not @form.valid?
    assert_equal ["muss akzeptiert werden"], @form.errors[:terms]
  end

  test "form should have acceptance validation for sepa_mandate" do
    @form.sepa_mandate = false
    assert_not @form.valid?
    assert_equal ["muss akzeptiert werden"], @form.errors[:sepa_mandate]
  end

  test "form should have a member" do
    assert_instance_of Member, @form.member
  end
end
