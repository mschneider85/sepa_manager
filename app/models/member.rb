class Member < ApplicationRecord
  include IbanFormatting

  has_paper_trail

  has_many :transactions, dependent: :nullify

  monetize :annual_fee_cents, numericality: { greater_than: 0 }

  validates :firstname, :lastname, :address, :zip, :city, :email, presence: true
  validates :iban, iban: true
  validates :entry_date, comparison: { less_than_or_equal_to: -> { Time.zone.today } }
  validates :account_holder, presence: true, length: { maximum: 70 }
  validate :uid_must_be_unique

  def name
    "#{firstname} #{lastname}"
  end

  def uid
    return unless entry_date && firstname && lastname && address

    "#{entry_date.iso8601}-#{uid_part_from(firstname)}-#{uid_part_from(lastname)}-#{uid_part_from(address)}"
  end

  private

  def uid_part_from(string)
    string.gsub(/[^0-9A-Za-z]/, "").slice(0, 2).upcase
  end

  def uid_must_be_unique
    return unless Member.where.not(id: id).any? { |member| member.uid == uid }

    errors.add(:uid, :taken)
  end
end
