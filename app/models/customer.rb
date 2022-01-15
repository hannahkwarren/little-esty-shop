class Customer < ApplicationRecord
  has_many :invoices
  has_many :transactions, :through => :invoices
  has_many :invoice_items, :through => :invoices
  has_many :items, :through => :invoice_items
  has_many :merchants, :through => :items

  def self.favorite_customers
    select('customers.*, count(customers.id) as count')
    .joins(:transactions)
    .where(transactions: { result: 'success' })
    .group('customers.id')
    .order('count')
    .limit(5)
  end

  def self.top_five_customers
    select("customers.*, count(transactions.id) as numtrans")
    .joins(:transactions)
    .group(:id)
    .where(transactions: {result: "success"})
    .order(numtrans: :desc)
    .limit(5)
  end

end
