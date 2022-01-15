require 'rails_helper'

RSpec.describe 'show page for a bulk discount' do
  it 'has shows the attributes for a bulk discount' do
    merchant = Merchant.create!(name: 'I am the merchant')
    merchant_not_included = Merchant.create!(name: 'I am not included merchant')
    discount_not_included = merchant_not_included.bulk_discounts.create!(title: 'not included discount',
                                                                         percentage: 100, qty_threshold: 1)
    discount_1 = merchant.bulk_discounts.create!(title: 'A', qty_threshold: 10, percentage: 90)
    discount_2 = merchant.bulk_discounts.create!(title: 'discount b', qty_threshold: 2, percentage: 75)
    visit merchant_bulk_discount_path(merchant, discount_1)

    within '.bulk-discount' do
      expect(page).to have_content("Bulk Discount - #{discount_1.title}")
      expect(page).to have_content("Must Purchase #{discount_1.qty_threshold} items to qualify")
      expect(page).to have_content("Percentage off: #{discount_1.percentage.to_s.concat('%')}")
      expect(page).to_not have_content("Bulk Discount - #{discount_2.title}")
      expect(page).to_not have_content("Must Purchase #{discount_2.qty_threshold} items to qualify")
      expect(page).to_not have_content("Percentage off: #{discount_2.percentage.to_s.concat('%')}")

      expect(page).to_not have_content("Percentage off: #{discount_not_included.percentage.to_s.concat('%')}")
    end
  end
  it 'has a link to edit the bulk discount' do
    merchant = Merchant.create!(name: 'I am the merchant')
    merchant_not_included = Merchant.create!(name: 'I am not included merchant')
    discount_not_included = merchant_not_included.bulk_discounts.create!(title: 'not included discount',
                                                                         percentage: 100, qty_threshold: 1)
    discount_1 = merchant.bulk_discounts.create!(title: 'A', qty_threshold: 10, percentage: 90)
    discount_2 = merchant.bulk_discounts.create!(title: 'discount b', qty_threshold: 2, percentage: 75)

    visit merchant_bulk_discount_path(merchant, discount_1)

    within '.bulk-discount' do
      click_link 'Edit Bulk Discount'

      expect(current_path).to eq(edit_merchant_bulk_discount_path(merchant, discount_1))
    end
  end
end
