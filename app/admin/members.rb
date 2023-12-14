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
      f.input :zip, input_html: { value: f.object.zip || Setting.default_zip }
      f.input :city, input_html: { value: f.object.city || Setting.default_city }
      f.input :email
      f.input :annual_fee
      f.input :iban
      f.input :account_holder
      f.input :entry_date, as: :date_select, selected: f.object.entry_date || Date.current, start_year: 2023
    end

    f.actions

    script type: "text/javascript" do
      raw("
        document.addEventListener('DOMContentLoaded', function() {
          var copyButton = document.createElement('button');
          copyButton.textContent = 'Autofill';
          copyButton.type = 'button';
          copyButton.addEventListener('click', function() {
            var firstname = document.getElementById('member_firstname').value;
            var lastname = document.getElementById('member_lastname').value;
            var memberName = firstname + ' ' + lastname;
            var accountHolder = document.getElementById('member_account_holder');
            accountHolder.value = memberName;
          });
          document.querySelector('#member_account_holder_input').append(copyButton);
        });
      ")
    end
  end

  index do
    selectable_column
    column :uid
    column :name
    column :address
    column "IBAN", :formatted_iban
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
