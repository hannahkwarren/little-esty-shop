class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_one :merchant, through: :item 
  has_many :bulk_discounts, through: :merchant
  enum status: ["pending", "packaged", "shipped"]

  def regular_price 
    self.unit_price * self.quantity
  end

  def applicable_discount
    discount = bulk_discounts.where('bulk_discounts.quantity <= ?', self.quantity).order(percentage: :desc).limit(1)
    discount.first
  end

  def discounted_price
    if applicable_discount != nil
      regular_price - (applicable_discount.percentage * regular_price / 100)
    else 
      regular_price
    end
  end

end
