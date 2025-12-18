class AddStatusToMembers < ActiveRecord::Migration[7.1]
  def change
    add_column :members, :status, :string, default: "active", null: false
  end
end
