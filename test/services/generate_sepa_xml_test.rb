require "test_helper"
require "nokogiri"

class GenerateSepaXmlTest < ActiveSupport::TestCase
  include ActionView::Helpers::NumberHelper

  def setup
    @transaction1 = transactions(:transaction_one)
    @transaction2 = transactions(:transaction_two)

    @service = GenerateSepaXml.new(ids: [@transaction1.id, @transaction2.id])
    @xml = @service.call
    @document = Nokogiri::XML(@xml)
  end

  test "call generates a SEPA XML string /w ibans included" do
    assert @xml.is_a?(String)
    assert_includes @xml, @transaction1.iban
    assert_includes @xml, @transaction2.iban
  end

  test "call generates a valid XML according to the schema" do
    schema = Nokogiri::XML::Schema(Rails.root.join("test/fixtures/files/pain.008.001.02.xsd"))

    assert_empty schema.validate(@document)
  end

  test "call generates XML wuth the correct Number of Transactions attribute " do
    number_of_transactions = @document.at("PmtInf/NbOfTxs").text

    assert_equal @service.ids.count.to_s, number_of_transactions
  end

  test "call generates XML with the correct control sum" do
    sum = @transaction1.amount + @transaction2.amount
    control_sum = @document.at("PmtInf/CtrlSum").text

    assert_equal number_with_precision(sum, precision: 2), control_sum
  end
end
