# RailsSettings Model
class Setting < RailsSettings::Base
  cache_prefix { "v1" }

  scope :creditor do
    field :creditor_name, type: :string
    field :bic, type: :string
    field :iban, type: :string
    field :creditor_identifier, type: :string
  end

  scope :default_values do
    field :default_transaction_text, type: :string
    field :default_zip, type: :string
    field :default_city, type: :string
  end

  # Define your fields
  # field :host, type: :string, default: "http://localhost:3000"
  # field :default_locale, default: "en", type: :string
  # field :confirmable_enable, default: "0", type: :boolean
  # field :admin_emails, default: "admin@rubyonrails.org", type: :array
  # field :omniauth_google_client_id, default: (ENV["OMNIAUTH_GOOGLE_CLIENT_ID"] || ""), type: :string, readonly: true
  # field :omniauth_google_client_secret, default: (ENV["OMNIAUTH_GOOGLE_CLIENT_SECRET"] || ""), type: :string, readonly: true
end
