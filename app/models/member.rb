class Member < ApplicationRecord
  include IbanFormatting

  has_paper_trail

  monetize :annual_fee_cents, numericality: { greater_than: 0 }

  validates :firstname, :lastname, :address, :zip, :city, :email, presence: true
  validates :iban, iban: true
  validates :entry_date, comparison: { less_than_or_equal_to: -> { Time.zone.today } }
  validates :account_holder, presence: true, length: { maximum: 70 }

  def name
    "#{firstname} #{lastname}"
  end

  def uid
    return unless persisted?

    "#{entry_date.iso8601}-#{uid_part_from(firstname)}-#{uid_part_from(lastname)}-#{uid_part_from(address)}"
  end

  private

  def uid_part_from(string)
    string.slice(0, 2).upcase
  end
end
