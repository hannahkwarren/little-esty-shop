require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name}
    it { should validate_presence_of :threshold}
    it { should validate_presence_of :discount}
  end
  describe 'relationships' do
    it { should belong_to :merchant}
  end

  describe 'instance methods' do
    it "converts the float to a percentage"  do
      merch_1 = Merchant.create!(name: "Shop Here")
      merch_2 = Merchant.create!(name: "Buy Here")

      discount_a = merch_1.bulk_discounts.create({name:"Discount A", discount: 0.20, threshold: 10 })
      discount_b = merch_1.bulk_discounts.create({name:"Discount B", discount: 0.30, threshold: 15 })
      discount_c = merch_2.bulk_discounts.create({name:"Discount C", discount: 0.25, threshold: 25 })

      expect(discount_a.float_to_percent).to eq(20.0)
      expect(discount_b.float_to_percent).to eq(30.0)
      expect(discount_c.float_to_percent).to eq(25.0)
    end
  end
end
