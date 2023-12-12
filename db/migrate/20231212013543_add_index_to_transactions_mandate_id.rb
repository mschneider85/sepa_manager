class AddIndexToTransactionsMandateId < ActiveRecord::Migration[7.1]
  def change
    add_index :transactions, :mandate_id, unique: true
  end
end
