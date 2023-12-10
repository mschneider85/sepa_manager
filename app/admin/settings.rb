ActiveAdmin.register_page "Settings" do
  controller { helper SettingsHelper }

  content title: "Settings" do
    all_settings_by_scope = Setting.defined_fields.reject { |field| field[:readonly] }.group_by { |field| field[:scope] }

    render partial: "admin/settings/index", locals: { all_settings_by_scope: all_settings_by_scope }
  end

  page_action :update, method: :post do
    @errors = ActiveModel::Errors.new(Setting.new)
    setting_params = params.require(:settings).permit!
    update_something = false

    setting_params.each_key do |key|
      setting = Setting.find_or_initialize_by(var: key)
      field = Setting.get_field(key)

      value = setting_params[key].presence
      setting.value = if field[:type] == :hash
                        value.present? ? YAML.safe_load(value) : nil
                      else
                        value&.strip
                      end

      update_something = true if setting.changed?
      setting.save
      @errors.merge!(setting.errors) unless setting.valid?
    end

    if @errors.any?
      flash[:error] = t("activeadmin.rails_setting_cache.update.error", details: @errors.full_messages.join(", "))
    else
      message = update_something ? "success" : "nothing_updated"
      flash[:success] = t("activeadmin.rails_setting_cache.update.#{message}")
    end

    redirect_back(fallback_location: admin_root_path)
  end
end
