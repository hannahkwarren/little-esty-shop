class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items
  scope :applied, -> { joins(:invoice_items).where('invoice_items.quantity >= bulk_discounts.qty_threshold', true) }

  def self.total_discounted_rev
    # applied.select('sum((invoice_items.unit_price * invoice_items.quantity) * ((100.0 - bulk_discounts.percentage) / 100)) as total')
    applied.select('invoice_items.*, sum((invoice_items.unit_price * invoice_items.quantity) * ((100.0 - bulk_discounts.percentage) / 100)) as total, bulk_discounts.id as bulk_id')
           .distinct('invoice_items.id')
           .group('bulk_discounts.id, invoice_items.id')
  end
end
