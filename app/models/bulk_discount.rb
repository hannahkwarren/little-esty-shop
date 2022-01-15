class BulkDiscount < ApplicationRecord
  validates :name, presence: true
  validates :threshold, presence: true
  validates :discount, presence: true
  belongs_to :merchant

  def float_to_percent
    discount * 100
  end
end
