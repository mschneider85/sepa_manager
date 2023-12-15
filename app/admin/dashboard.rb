# frozen_string_literal: true

require "yaml"

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    # Setting Panels
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
        column("Modified by") { |v| link_to AdminUser.find(v.whodunnit).email, [:admin, AdminUser.find(v.whodunnit)] }
      end
    end
  end
end
