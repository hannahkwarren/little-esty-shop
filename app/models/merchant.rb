class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  # def favorite_customers
  #   # get items for the merchant_id
  #   # get invoice_items with this item id
  #   # get invoice id from invoice_items
  #   # look up transactions and customers with the invoice_id
  #   require "pry"; binding.pry
  #   joins({items: :invoice_items}).where(merchants: { merchant_id: self.id } )
  # end
end
