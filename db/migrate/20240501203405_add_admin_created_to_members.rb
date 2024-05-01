class AddAdminCreatedToMembers < ActiveRecord::Migration[7.1]
  def change
    add_column :members, :admin_created, :boolean, null: false, default: false

    up_only do
      Member.update_all(admin_created: true)
    end
  end
end
