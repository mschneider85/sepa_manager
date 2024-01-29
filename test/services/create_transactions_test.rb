require "test_helper"

class CreateTransactionsTest < ActiveSupport::TestCase
  def setup
    @member1 = members(:one)
    @member2 = members(:two)

    Transaction.delete_all
    @service = CreateTransactions.new
    @service.member_ids = [@member1.id, @member2.id]
  end

  test "call creates transactions for the given members" do
    assert_difference "Transaction.count", 2 do
      @service.call
    end

    transaction1 = Transaction.find_by(iban: @member1.iban)
    assert_not_nil transaction1
    assert_equal @member1.account_holder, transaction1.name
    assert_equal @member1.annual_fee_cents, transaction1.amount_cents
    assert_equal @member1.uid, transaction1.mandate_id
    assert_equal @member1.entry_date, transaction1.mandate_date_of_signature
    assert_equal "CORE", transaction1.local_instrument
    assert_equal "FRST", transaction1.sequence_type

    transaction2 = Transaction.find_by(iban: @member2.iban)
    assert_not_nil transaction2
    assert_equal @member2.account_holder, transaction2.name
    assert_equal @member2.annual_fee_cents, transaction2.amount_cents
    assert_equal @member2.uid, transaction2.mandate_id
    assert_equal @member2.entry_date, transaction2.mandate_date_of_signature
    assert_equal "CORE", transaction2.local_instrument
    assert_equal "FRST", transaction2.sequence_type
  end

  test "call creates no transactions when there are no members" do
    @service.member_ids = []
    assert_no_difference "Transaction.count" do
      @service.call
    end
  end

  test "determine_sequence_type returns 'FRST' when member has no transactions" do
    member = Member.new
    assert_equal "FRST", @service.determine_sequence_type(member)
  end

  test "determine_sequence_type returns 'RCUR' when member has transactions" do
    member = Member.new
    member.transactions.build
    assert_equal "RCUR", @service.determine_sequence_type(member)
  end

  test "call creates transactions with RCUR when member has transactions" do
    2.times { @service.call }

    assert_equal 2, Transaction.where(sequence_type: "RCUR").length
  end
end
