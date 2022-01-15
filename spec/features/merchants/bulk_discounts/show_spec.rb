require 'rails_helper'

RSpec.describe 'show page for a bulk discount' do
  it 'has shows the attributes for a bulk discount' do
    merchant = Merchant.create!(name: 'I am the merchant')
    discount_1 = merchant.bulk_discounts.create!(title: 'A', qty_threshold: 10, percentage: 90)
    discount_2 = merchant.bulk_discounts.create!(title: 'discount b', qty_threshold: 10, percentage: 10)
    visit merchant_bulk_discount_path(merchant, discount_1)

    within '.bulk-discount' do
      expect(page).to have_content("Bulk Discount - #{discount_1.title}")
      expect(page).to have_content("Must Purchase #{discount_1.qty_threshold} items to qualify")
      expect(page).to have_content("Percentage off: #{discount_1.percentage.to_s.concat('%')}")
    end
  end
end
