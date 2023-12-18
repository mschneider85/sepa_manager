class AddMemberIdToTransactions < ActiveRecord::Migration[7.1]
  def change
    add_reference :transactions, :member, index: true
  end
end
