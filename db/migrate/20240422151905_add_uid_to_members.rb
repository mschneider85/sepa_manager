class AddUidToMembers < ActiveRecord::Migration[7.1]
  def change
    add_column :members, :uid, :string

    up_only do
      Member.find_each do |member|
        member.set_uid
        member.update_column(:uid, member.uid)
      end
    end
  end
end
