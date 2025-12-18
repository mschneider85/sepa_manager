class Member < ApplicationRecord
  include IbanFormatting

  has_paper_trail

  has_many :transactions, dependent: :nullify

  monetize :annual_fee_cents, numericality: { greater_than: 0 }

  enum :status,
       {
         active: "active",
         inactive: "inactive",
         volunteer: "volunteer"
       },
       default: "active",
       validate: true

  scope :confirmed, -> { where(confirmed: true) }

  validates :firstname, :lastname, :address, :zip, :city, :email, presence: true
  validates :iban, iban: true
  validates :entry_date, comparison: { less_than_or_equal_to: -> { Time.zone.today } }
  validates :account_holder, presence: true, length: { maximum: 70 }

  generates_token_for :confirmation do
    confirmed?
  end

  before_create :set_uid

  def name
    "#{firstname} #{lastname}"
  end

  def set_uid
    self.uid = generate_unique_uid
  end

  def uid
    super || default_uid
  end

  def confirm!
    update(confirmed: true)
  end

  def status_css_klass
    {
      "inactive" => "bg-danger",
      "volunteer" => "bg-info"
    }[status]
  end

  private

  def default_uid
    return unless entry_date && firstname && lastname && address

    "#{entry_date.iso8601}-#{uid_part_from(firstname)}-#{uid_part_from(lastname)}-#{uid_part_from(address)}"
  end

  def generate_unique_uid(suffix = 0)
    uid = default_uid
    uid += "-#{suffix}" if suffix.positive?
    return uid unless Member.where.not(id: id).exists?(uid: uid)

    generate_unique_uid(suffix + 1)
  end

  def uid_part_from(string)
    string.gsub(/[^0-9A-Za-z]/, "").slice(0, 2).upcase
  end
end
