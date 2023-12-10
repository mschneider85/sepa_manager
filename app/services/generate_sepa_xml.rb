class GenerateSepaXml
  include ActiveModel::Model

  attr_writer :ids

  def ids
    @ids || []
  end

  def call
    sdd = SEPA::DirectDebit.new(creditor_attributes)
    transactions.each do |transaction|
      sdd.add_transaction(transaction_attributes(transaction))
    end
    sdd.to_xml
  end

  private

  def transactions
    Transaction.where(id: ids)
  end

  def creditor_attributes
    {
      # Name of the initiating party and creditor, in German: "Auftraggeber"
      # String, max. 70 char
      name: Setting.creditor_name,
      #
      # OPTIONAL: Business Identifier Code (SWIFT-Code) of the creditor
      # String, 8 or 11 char
      bic: Setting.bic,
      #
      # International Bank Account Number of the creditor
      # String, max. 34 chars
      iban: Setting.iban,
      #
      # Creditor Identifier, in German: Gläubiger-Identifikationsnummer
      # String, max. 35 chars
      creditor_identifier: Setting.creditor_identifier
    }.compact_blank
  end

  def transaction_attributes(transaction)
    {
      # Name of the debtor, in German: "Zahlungspflichtiger"
      # String, max. 70 char
      name: transaction.name,
      #
      # OPTIONAL: Business Identifier Code (SWIFT-Code) of the debtor's account
      # String, 8 or 11 char
      bic: transaction.bic,
      #
      # International Bank Account Number of the debtor's account
      # String, max. 34 chars
      iban: transaction.iban,
      #
      # Amount
      # Number with two decimal digit
      amount: transaction.amount.to_f,
      #
      # OPTIONAL: Currency, EUR by default (ISO 4217 standard)
      # String, 3 char
      currency: transaction.amount_currency,
      #
      # OPTIONAL: Instruction Identification, will not be submitted to the debtor
      # String, max. 35 char
      instruction: transaction.instruction,
      #
      # OPTIONAL: End-To-End-Identification, will be submitted to the debtor
      # String, max. 35 char
      reference: transaction.reference,
      #
      # OPTIONAL: Unstructured remittance information, in German "Verwendungszweck"
      # String, max. 140 char
      remittance_information: transaction.remittance_information,
      #
      # Mandate identifikation, in German "Mandatsreferenz"
      # String, max. 35 char
      mandate_id: transaction.mandate_id,
      #
      # Mandate Date of signature, in German "Datum, zu dem das Mandat unterschrieben wurde"
      # Date
      mandate_date_of_signature: transaction.mandate_date_of_signature,
      #
      # Local instrument, in German "Lastschriftart"
      # One of these strings:
      #   'CORE' ("Basis-Lastschrift")
      #   'COR1' ("Basis-Lastschrift mit verkürzter Vorlagefrist")
      #   'B2B' ("Firmen-Lastschrift")
      local_instrument: transaction.local_instrument,
      #
      # Sequence type
      # One of these strings:
      #   'FRST' ("Erst-Lastschrift")
      #   'RCUR' ("Folge-Lastschrift")
      #   'OOFF' ("Einmalige Lastschrift")
      #   'FNAL' ("Letztmalige Lastschrift")
      sequence_type: transaction.sequence_type,
      #
      # OPTIONAL: Requested collection date, in German "Fälligkeitsdatum der Lastschrift"
      # Date
      requested_date: transaction.requested_date,
      #
      # OPTIONAL: Enables or disables batch booking, in German "Sammelbuchung / Einzelbuchung"
      # True or False
      batch_booking: true
    }.reject { |_, v| v.nil? || v == "" }
  end
end
