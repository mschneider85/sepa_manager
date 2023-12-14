module IbanFormatting
  extend ActiveSupport::Concern

  included do
    def formatted_iban
      iban.gsub(/\s/, "").gsub(/(.{4})(?=.)/, '\1 ')
    end
  end
end
