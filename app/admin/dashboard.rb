# frozen_string_literal: true

require "yaml"

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    # KPI Panels
    h3 "Members"
    columns do
      grouped_members = Member.confirmed.group(:status).count
      Member.statuses.each_key do |status|
        column do
          panel status.titleize do
            para grouped_members[status].to_i,
                 style: "font-size: 3em; text-align: center; margin: 20px 0 8px;"
            para link_to("View members",
                         admin_members_path(q: { confirmed_eq: true, status_eq: status })),
                 style: "text-align: center; font-size: 0.95em; margin: 0;"
          end
        end
      end
    end

    # Setting Panels
    h3 "Settings"
    editable_fields = Setting.defined_fields
                        .reject { |field| field[:readonly] }
                        .group_by { |field| field[:scope] }

    editable_fields.each do |group, fields|
      panel group.to_s.titleize do
        attributes_table_for Setting do
          fields.each do |field|
            row(field.key) { Setting.send(field.key) }
          end
        end
      end
    end

    # PaperTrail Panel
    h3 "Audit Trail"
    panel "Recently updated content" do
      table_for PaperTrail::Version.order(id: :desc).limit(5) do
        column("Item") do |v|
          if v.item.present?
            link_to(v.item.name, [:admin, v.item])
          elsif v.object.present?
            item = YAML.load(v.object, permitted_classes: [Date, Time])
            item["name"]
          else
            object = PaperTrail::Version
                       .order(:created_at)
                       .where.not(object: :nil)
                       .where(item_type: v.item_type, item_id: v.item_id)
                       .last&.object
            if object.present?
              item = YAML.load(object, permitted_classes: [Date, Time])
              item["name"]
            else
              "Deleted #{v.item_type.underscore.humanize}"
            end
          end
        end
        column("Type") { |v| v.item_type.underscore.humanize }
        column("Event") { |v| status_tag(v.event) }
        column("Modified at") { |v| v.created_at.to_fs :long }
        column("Modified by") do |v|
          admin_user = AdminUser.find_by(id: v.whodunnit)
          if admin_user.present?
            link_to admin_user.email, [:admin, admin_user]
          else
            "Registration form"
          end
        end
      end
    end
  end
end
