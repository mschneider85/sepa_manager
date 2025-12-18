class RegistrationForm
  include ActiveModel::Model

  attr_accessor :email, :firstname, :lastname, :address, :zip, :city, :annual_fee, :account_holder, :terms, :sepa_mandate
  attr_reader :iban

  validates :firstname, :lastname, :address, :zip, :city, :email, presence: true
  validates :iban, iban: true
  validates :annual_fee, numericality: { greater_than_or_equal_to: 15 }
  validates :account_holder, presence: true, length: { maximum: 70 }
  validates :terms, :sepa_mandate, acceptance: true

  def save
    valid? && member.save
  end

  def iban=(value)
    @iban = value&.upcase&.gsub(/\s+/, "")
  end

  def member
    @member ||=
      Member.new(
        email: email,
        firstname: firstname,
        lastname: lastname,
        address: address,
        zip: zip,
        city: city,
        annual_fee: annual_fee,
        iban: iban,
        account_holder: account_holder,
        entry_date: Date.current
      )
  end
end
