module SettingsHelper
  def field_for_setting(form, setting)
    case setting.type
    when :boolean
      value = Setting.send("#{setting.key}?")
      form.check_box setting.key, checked: value, label: false
    when :array
      value = Setting.send(setting.key.to_s).join("\n")
      form.text_area setting.key, value: value, label: false, placeholder: setting.default.join("\n")
    when :integer
      form.number_field setting.key, label: false, value: Setting.send(setting.key.to_s), placeholder: setting.default
    when :hash
      value = YAML.dump(Setting.send(setting.key.to_s)).gsub(/^---.*\n*/,'')
      form.text_area setting.key, value: value, label: false, placeholder: YAML.dump(setting.default).gsub(/^---.*\n*/,'')
    else
      if setting[:options].key?(:option_values)
        form.select setting.key, setting[:options][:option_values], label: false, selected: Setting.send(setting.key.to_s)
      else
        value = Setting.send(setting.key.to_s)
        form.text_field setting.key, label: false, value: value, placeholder: setting.default
      end
    end
  end
end
