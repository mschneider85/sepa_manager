class CreateMembers < ActiveRecord::Migration[7.1]
  def change
    create_table :members do |t|
      t.string :firstname
      t.string :lastname
      t.string :address
      t.string :zip
      t.string :city
      t.string :email
      t.monetize :annual_fee
      t.string :iban
      t.string :account_holder
      t.date :entry_date

      t.timestamps
    end
  end
end
