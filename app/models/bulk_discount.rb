class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items
  validates :percentage, numericality: { only_integer: true }
  validates :percentage, numericality: { less_than: 100 }
  validates :percentage, numericality: { greater_than: 0 }
  validates :title, :qty_threshold, :percentage, presence: true
end
