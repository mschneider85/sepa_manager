class AddConfirmationToMembers < ActiveRecord::Migration[7.1]
  def change
    add_column :members, :confirmed, :boolean, default: false, null: false

    up_only do
      Member.update_all(confirmed: true)
    end
  end
end
