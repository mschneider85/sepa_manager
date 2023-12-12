ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  member_action :reset_password, method: :put do
    resource.send_reset_password_instructions
    redirect_to resource_path, notice: "Password reset email sent"
  end

  action_item :reset_password, only: :show do
    link_to "Send Reset Password Instruction", reset_password_admin_admin_user_path(resource), method: :put
  end
end
