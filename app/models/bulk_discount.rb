class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items
  scope :applied, -> { joins(:invoice_items).where('invoice_items.quantity >= bulk_discounts.qty_threshold', true) }
end
