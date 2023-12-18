class Transaction < ApplicationRecord
  include IbanFormatting

  has_paper_trail

  belongs_to :member

  enum local_instrument: { CORE: 0, COR1: 1, B2B: 2 }
  enum sequence_type: { FRST: 0, RCUR: 1, OOFF: 2, FNAL: 3 }

  monetize :amount_cents, numericality: { greater_than: 0 }

  validates :name, presence: true, length: { maximum: 70 }
  validates :bic, bic: true, allow_blank: true
  validates :iban, iban: true
  validates :instruction, length: { maximum: 35 }, valid_characters: true
  validates :reference, length: { maximum: 35 }
  validates :remittance_information, length: { maximum: 140 }
  validates :mandate_id, presence: true, length: { maximum: 35 }, valid_characters: true
  validates :mandate_date_of_signature, comparison: { less_than_or_equal_to: -> { Time.zone.today } }
  validates :local_instrument, :sequence_type, presence: true
  validates :requested_date, comparison: { greater_than_or_equal_to: -> { Time.zone.tomorrow } }, allow_blank: true
end
