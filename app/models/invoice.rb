class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items 
  has_many :bulk_discounts, through: :merchants

  enum status: ["in progress", "completed", "cancelled"]

  def self.merchants_invoices(merchant)
    joins(:invoice_items, :items)
    .where(items: { merchant_id: merchant.id })
    .distinct(:invoice_id)
  end
  
  def self.incomplete_invoices
    where(status: "in progress").order(created_at: :asc).distinct(:id)
  end
  
  def total_revenue(merchant = nil)
    if merchant != nil 
      ii = invoice_items.joins(:item).where('items.merchant_id = ?', merchant.id)
      ii.sum("invoice_items.unit_price * invoice_items.quantity")
    else
      invoice_items.sum("unit_price * quantity")
    end
  end

  def total_discounted_revenue(merchant = nil)
    total = 0
    
    if merchant != nil
      current_invoice_items = invoice_items.joins(:item).where('items.merchant_id = ?', merchant.id)
    else 
      current_invoice_items = invoice_items
    end

    current_invoice_items.each do |inv_item|
      total += inv_item.discounted_price 
    end

    total
  end
  
end
