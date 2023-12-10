class ValidCharactersValidator < ActiveModel::EachValidator
  VALID_CHARACTERS_REGEX = %r{\A[A-Za-z0-9+|\?/\-:\(\)\.,'\s]*\z}

  def validate_each(record, attribute, value)
    return if value.blank? || VALID_CHARACTERS_REGEX.match?(value)

    record.errors.add(attribute, (options[:message] || "valid characters are A-Za-z0-9+|?/-:(),.' and space"))
  end
end
