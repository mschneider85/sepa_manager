require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  def new_valid_transaction
    Transaction.new(name: "Jane Roe", iban: "DE02300209000106531065", amount_cents: 1500, remittance_information: "Thanks", mandate_id: "2023-11-01-JA-RO-FR", mandate_date_of_signature: "2023-11-29", local_instrument: "CORE", sequence_type: "FRST")
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

  test "should not be valid with duplicate mandate_id" do
    transaction = new_valid_transaction
    transaction.mandate_id = transactions(:transaction_one).mandate_id
    transaction.valid?
    assert_not_empty transaction.errors[:mandate_id], "No validation error for mandate_id present"
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
end
