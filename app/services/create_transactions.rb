class CreateTransactions
  include ActiveModel::Model

  attr_writer :member_ids

  def member_ids
    @member_ids || []
  end

  def call
    Member.includes(:transactions).where(id: member_ids).find_each do |member|
      Transaction.create!(
        member: member,
        name: member.account_holder,
        iban: member.iban,
        amount_cents: member.annual_fee_cents,
        remittance_information: remittance_information,
        mandate_id: member.uid,
        mandate_date_of_signature: member.entry_date,
        local_instrument: "CORE",
        sequence_type: determine_sequence_type(member)
      )
    end
  end

  def determine_sequence_type(member)
    if member.transactions.any?
      "RCUR"
    else
      "FRST"
    end
  end

  private

  def remittance_information
    @remittance_information ||= Setting.default_transaction_text
  end
end
