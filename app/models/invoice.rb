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
  
  # def applicable_discounts(merchant)
  #   # invoice_items.joins(item: [{merchant: :bulk_discounts}])
  #   # .where("bulk_discounts.quantity <= invoice_items.quantity AND items.merchant_id = #{merchant.id}").select('bulk_discounts.percentage AS b_percentage')
  #   # binding.pry
  #   # bulk_discounts.joins(merchant: {merchant_id: merchant.id})
  #   # .joins(items: :invoice_items)
  #   # .where
  #   # bulk_discounts.where('merchant_id: 100 && invoice_items.quantity >= bulk_discounts.quantity')
  #   # bulk_discounts.where('invoice_items.quantity >= bulk_discounts.quantity AND merchants.id = ?', merchant.id)
   
  #   # select('sum(bulk_discount.quantity * bulk_discount.percentage * invoice_items.unit_price) AS sum').joins(:bulk_discounts).where('bulk_discount.quantity <= invoice_items.quantity')
  #   # result = invoice_items.includes(:bulk_discounts).where('bulk_discount.quantity <= invoice_items.quantity')
  # end

  # def applicable_discounts(merchant) 
  #   invoice_items.where('bulk_discounts.quantity <= invoice_items.quantity')
  #   .joins(:bulk_discounts)
  #   .select('sum(bulk_discounts.quantity * invoice_items.unit_price * bulk_discounts.percentage) as sum_per_item')
  #   .group(:id)
  #   .having('bulk_discounts.merchant_id = ?', merchant.id)
  #   .order('bulk_discounts.percentage desc')
  #   .limit(1)
  # end

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
