ActiveAdmin.register Member do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :firstname, :lastname, :address, :zip, :city, :email, :annual_fee, :iban, :account_holder, :entry_date
  #
  # or
  #
  # permit_params do
  #   permitted = [:firstname, :lastname, :address, :zip, :city, :email, :iban, :account_holder, :entry_date]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  batch_action :create_transactions_for do |ids|
    CreateTransactions.new(member_ids: ids).call
    redirect_to collection_path, alert: "The transactions have been created."
  end

  form do |f|
    inputs do
      f.input :firstname
      f.input :lastname
      f.input :address
      f.input :zip
      f.input :city
      f.input :email
      f.input :annual_fee
      f.input :iban
      f.input :account_holder
      f.input :entry_date, input_html: { value: f.object.entry_date || Date.current }
    end

    f.actions
  end

  index do
    selectable_column
    column :uid
    column :name
    column :address
    actions
  end

  sidebar :versionate, partial: "layouts/version", only: :show

  controller do
    def show
      @member = Member.includes(versions: :item).find(params[:id])
      @versions = @member.versions
      @member = @member.versions[params[:version].to_i].reify if params[:version]
      show!
    end
  end

  member_action :history do
    @member = Member.find(params[:id])
    @versions = PaperTrail::Version.where(item_type: "Member", item_id: @member.id)
    render "layouts/history"
  end

  action_item :history, only: :show do
    link_to "Version History", history_admin_member_path(member)
  end

  action_item :view, only: :history do
    link_to "View Member", admin_member_path(member)
  end
end
