require 'rails_helper'

RSpec.describe 'a merchants bulk discounts index page' do
  it 'has the details of all my discounts and links to their show pages' do
    merchant = Merchant.create!(name: 'I am the merchant')
    discount_1 = merchant.bulk_discounts.create!(title: 'A', qty_threshold: 10, percentage: 90)
    discount_2 = merchant.bulk_discounts.create!(title: 'A', qty_threshold: 10, percentage: 10)
    discount_3 = merchant.bulk_discounts.create!(title: 'A', qty_threshold: 10, percentage: 10)
    visit merchant_bulk_discounts_path(merchant)

    within ".discount-#{discount_1.id}" do
      expect(page).to have_content("Discount: #{discount_1.title}")
      expect(page).to have_content("Qualifying quantity: #{discount_1.qty_threshold}")
      expect(page).to have_content("Percentage off: #{discount_1.percentage.to_s.concat('%')}")
    end
  end
end
