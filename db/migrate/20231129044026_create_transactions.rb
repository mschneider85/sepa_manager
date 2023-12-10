class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.string :name
      t.string :bic
      t.string :iban
      t.monetize :amount
      t.string :instruction
      t.string :reference
      t.text :remittance_information
      t.string :mandate_id
      t.date :mandate_date_of_signature
      t.integer :local_instrument, default: 0, null: false
      t.integer :sequence_type
      t.date :requested_date

      t.timestamps
    end
  end
end
