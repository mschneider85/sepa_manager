ActiveAdmin.register Transaction do
  permit_params :name,
                :bic,
                :iban,
                :amount,
                :instruction,
                :reference,
                :remittance_information,
                :mandate_id,
                :mandate_date_of_signature,
                :local_instrument,
                :sequence_type,
                :requested_date

  form do |f|
    inputs "Debtor bank data" do
      f.input :name, required: true, input_html: { maxlength: 70 }, hint: "max 70 characters"
      f.input :bic, label: "BIC"
      f.input :iban, required: true, label: "IBAN"
    end

    inputs "Transaction details" do
      f.input :amount, required: true
      f.input :instruction, label: "Instruction  Identification", input_html: { maxlength: 35 }, hint: "max 35 characters, A-Za-z0-9+|?/-:(),.' and space"
      f.input :reference, input_html: { maxlength: 35 }, hint: "max 35 characters"
      f.input :remittance_information, input_html: { value: f.object.remittance_information || Transaction.last&.remittance_information }, hint: "max 140 characters"
    end

    inputs "Mandate" do
      f.input :mandate_id, required: true, label: "Mandate ID", hint: "max 35 characters, A-Za-z0-9+|?/-:(),.' and space", input_html: { value: f.object.mandate_id || SecureRandom.hex }
      f.input :mandate_date_of_signature, required: true
    end

    inputs "Additional settings" do
      f.input :local_instrument, required: true
      f.input :sequence_type, required: true, hint: "FRST: first, RCUR: recurrent, OOFF: one-off, FNAL: final"
      f.input :requested_date
    end

    f.actions
  end

  batch_action :export_sepa_xml do |ids|
    response = GenerateSepaXml.new(ids: ids).call
    send_data(response, type: "application/xml", filename: "sepa_#{Time.current.iso8601}.xml")
  end

  index do
    selectable_column
    id_column
    column :name
    column :iban
    column :amount
    actions
  end
end
