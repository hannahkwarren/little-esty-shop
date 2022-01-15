require 'rails_helper'

RSpec.describe 'a merchants bulk discounts index page' do
  it 'has the details of all my discounts and links to their show pages' do
    merchant = Merchant.create!(name: 'I am the merchant')
    discount_1 = merchant.bulk_discounts.create!(title: 'A', qty_threshold: 10, percentage: 90)
    discount_2 = merchant.bulk_discounts.create!(title: 'B', qty_threshold: 10, percentage: 10)
    discount_3 = merchant.bulk_discounts.create!(title: 'C', qty_threshold: 10, percentage: 10)
    visit merchant_bulk_discounts_path(merchant)

    within ".discount-#{discount_1.id}" do
      expect(page).to have_link(discount_1.title)
      expect(page).to have_content("Qualifying quantity: #{discount_1.qty_threshold}")
      expect(page).to have_content("Percentage off: #{discount_1.percentage.to_s.concat('%')}")
      click_link discount_1.title

      expect(current_path).to eq(merchant_bulk_discount_path(merchant, discount_1))
    end
    visit merchant_bulk_discounts_path(merchant)

    within ".discount-#{discount_2.id}" do
      expect(page).to have_link(discount_2.title)
      expect(page).to have_content("Qualifying quantity: #{discount_2.qty_threshold}")
      expect(page).to have_content("Percentage off: #{discount_2.percentage.to_s.concat('%')}")
      click_link discount_2.title

      expect(current_path).to eq(merchant_bulk_discount_path(merchant, discount_2))
    end
    visit merchant_bulk_discounts_path(merchant)

    within ".discount-#{discount_3.id}" do
      expect(page).to have_link(discount_3.title)
      expect(page).to have_content("Qualifying quantity: #{discount_3.qty_threshold}")
      expect(page).to have_content("Percentage off: #{discount_3.percentage.to_s.concat('%')}")
      click_link discount_3.title

      expect(current_path).to eq(merchant_bulk_discount_path(merchant, discount_3))
    end
  end
  it 'has a link to create a new bulk discount' do
    merchant = Merchant.create!(name: 'I am the merchant')
    visit merchant_bulk_discounts_path(merchant)
    within '.new-discount' do
      click_link 'New Bulk Discount'
      expect(current_path).to eq(new_merchant_bulk_discount_path(merchant))
    end
  end
  it 'has a button to delete each bulk discount' do
    merchant = Merchant.create!(name: 'I am the merchant')
    discount_1 = merchant.bulk_discounts.create!(title: 'A', qty_threshold: 10, percentage: 90)
    discount_2 = merchant.bulk_discounts.create!(title: 'discount b', qty_threshold: 10, percentage: 10)
    discount_3 = merchant.bulk_discounts.create!(title: 'C', qty_threshold: 10, percentage: 10)
    visit merchant_bulk_discounts_path(merchant)
    within ".discount-#{discount_1.id}" do
      click_button 'Delete Bulk Discount'

      expect(current_path).to eq(merchant_bulk_discounts_path(merchant))
    end
    expect(page).to_not have_link(discount_1.title)
    within ".discount-#{discount_2.id}" do
      click_button 'Delete Bulk Discount'

      expect(current_path).to eq(merchant_bulk_discounts_path(merchant))
    end
    expect(page).to_not have_link(discount_2.title)
    within ".discount-#{discount_3.id}" do
      click_button 'Delete Bulk Discount'

      expect(current_path).to eq(merchant_bulk_discounts_path(merchant))
    end
    expect(page).to_not have_link(discount_3.title)
  end
end
