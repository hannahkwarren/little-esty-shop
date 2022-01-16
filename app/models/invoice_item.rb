class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_many :merchants, through: :item
  has_many :bulk_discounts, through: :merchants
  scope :applied, -> { joins(:bulk_discounts).where('quantity >= bulk_discounts.qty_threshold', true) }
  enum status: %w[pending packaged shipped]

  def discount
    bulk_discounts.where('bulk_discounts.qty_threshold <= ?', quantity).order(percentage: :desc).limit(1).first
  end

  def discounted_rev
    if discount.present?
      ((100.0 - discount.percentage) / 100) * (unit_price * quantity)
    else
      unit_price * quantity
    end
  end
end
