# frozen_string_literal: true

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    panel "Settings" do
      table_for Setting do
        column :creditor_name
        column :bic
        column :iban
        column :creditor_identifier
      end
    end

    section "Recently updated content" do
      table_for PaperTrail::Version.order(id: :desc).limit(20) do # Use PaperTrail::Version if this throws an error
        column("Item") { |v| v.item.present? ? link_to(v.item.name, [:admin, v.item]) : "-" } # Uncomment to display as link
        column("Type") { |v| v.item_type.underscore.humanize }
        column("Modified at") { |v| v.created_at.to_fs :long }
        column("Admin") { |v| link_to AdminUser.find(v.whodunnit).email, [:admin, AdminUser.find(v.whodunnit)] }
      end
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end
end
