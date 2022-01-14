class BulkDiscount < ApplicationRecord
  validates :name, presence: true
  validates :threshold, presence: true
  validates :discount, presence: true
  belongs_to :merchant
end
