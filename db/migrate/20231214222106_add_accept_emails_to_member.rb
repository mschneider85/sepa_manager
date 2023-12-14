class AddAcceptEmailsToMember < ActiveRecord::Migration[7.1]
  def change
    add_column :members, :accept_emails, :boolean, default: true, null: false
  end
end
