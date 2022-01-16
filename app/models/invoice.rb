class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants
  scope :applied, -> { joins(:invoice_items).where('invoice_items.quantity >= bulk_discounts.qty_threshold', true) }
  enum status: ['in progress', 'completed', 'cancelled']

  def self.merchants_invoices(merchant)
    joins(:items).where(items: { merchant_id: merchant.id }).distinct(:invoice_id)
  end

  def total_revenue
    invoice_items.sum('unit_price * quantity')
  end

  def self.incomplete_invoices
    where(status: 'in progress').order(created_at: :asc).distinct(:id)
  end

  def discounted_total_rev
    invoice_items.map(&:discounted_rev).sum.round
  end
end
