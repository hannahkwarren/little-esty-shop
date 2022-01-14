class Merchant < ApplicationRecord
  has_many :items
  has_many :bulk_discounts
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  enum status: %i[disabled enabled]

  def merchants_invoices
    invoices.order(created_at: :asc)
  end

  def items_ready_to_ship
    invoice_items.order(created_at: :asc).where(status: 1)
  end

  def merchants_favorite_customers
    customers.favorite_customers
  end

  def self.enabled_merchants
    where(status: 1)
  end

  def self.disabled_merchants
    where(status: 0)
  end

  def self.top_5_merchants_by_revenue
    select('merchants.id, merchants.name, sum(invoice_items.unit_price * invoice_items.quantity) AS total_revenue')
      .joins(:invoice_items, :transactions)
      .where(transactions: { result: 'success' })
      .group('merchants.id')
      .order('total_revenue desc')
      .limit(5)
  end

  def best_day
    invoice = invoices.joins(:transactions)
                      .select('invoices.created_at AS date, count(transactions.id) AS count_trans')
                      .where(transactions: { result: :success })
                      .group('date')
                      .order(count_trans: :desc)
                      .limit(1)

    invoice[0].date
  end
end
