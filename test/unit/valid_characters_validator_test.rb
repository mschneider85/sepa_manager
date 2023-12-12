require "test_helper"

class ValidCharactersValidatorTest < ActiveSupport::TestCase
  class Validatable
    include ActiveModel::Validations
    attr_accessor :name

    validates :name, valid_characters: true
  end

  test "should be valid when name contains only valid characters" do
    validatable = Validatable.new
    validatable.name = "John Doe"
    assert validatable.valid?, "Expected validatable to be valid"
  end

  test "should not be valid when name contains invalid characters" do
    validatable = Validatable.new
    validatable.name = "John Doe!"
    assert_not validatable.valid?, "Expected validatable to not be valid"
    assert_includes validatable.errors[:name], "valid characters are A-Za-z0-9+|?/-:(),.' and space"
  end
end
