require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  def new_valid_transaction
    Transaction.new(member: members(:two), name: "Jane Roe", iban: "DE02300209000106531065", amount_cents: 1500, remittance_information: "Thanks", mandate_id: "2023-11-01-JA-RO-FR", mandate_date_of_signature: "2023-11-29", local_instrument: "CORE", sequence_type: "FRST")
  end

  test "should not be valid without name" do
    transaction = new_valid_transaction
    transaction.name = nil
    transaction.valid?
    assert_not_empty transaction.errors[:name], "No validation error for name present"
  end

  test "should not be valid without iban" do
    transaction = new_valid_transaction
    transaction.iban = nil

    transaction.valid?
    assert_not_empty transaction.errors[:iban], "No validation error for iban present"
  end

  test "should not be valid with non-numeric amount_cents" do
    transaction = new_valid_transaction
    transaction.amount_cents = "fifteen hundred"
    transaction.valid?
    assert_not_empty transaction.errors[:amount_cents], "No validation error for amount_cents present"
  end

  test "should be valid with valid attributes" do
    transaction = new_valid_transaction
    assert transaction.valid?, "Transaction was not valid with valid attributes"
  end

  test "should save transaction with valid attributes" do
    transaction = new_valid_transaction
    assert transaction.save, "Did not save the transaction with valid attributes"
  end

  test "versioning on create" do
    transaction = new_valid_transaction
    transaction.save
    assert_equal 1, transaction.versions.size
    assert_equal "create", transaction.versions.last.event
  end

  test "versioning on update" do
    transaction = new_valid_transaction
    transaction.save
    transaction.update(name: "New Name")
    assert_equal 2, transaction.versions.size
    assert_equal "update", transaction.versions.last.event
    assert_not_equal "New Name", transaction.versions.last.reify.name
  end

  test "versioning on destroy" do
    transaction = new_valid_transaction
    transaction.save
    transaction.destroy
    assert_equal 2, transaction.versions.size
    assert_equal "destroy", transaction.versions.last.event
  end
end
