class RemoveUniqueConstraintOnTransactionsMandateId < ActiveRecord::Migration[7.1]
  def change
    remove_index :transactions, :mandate_id, unique: true
  end
end
