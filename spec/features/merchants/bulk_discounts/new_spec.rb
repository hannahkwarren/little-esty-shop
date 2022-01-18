require 'rails_helper'

RSpec.describe 'a merchants bulk discount new page' do
  it 'has a form to create a new bulk_discount' do
    merchant = Merchant.create!(name: 'I am the merchant')
    visit new_merchant_bulk_discount_path(merchant)

    within '.new-form' do
      fill_in 'Title', with: 'D'
      fill_in 'bulk_discount_qty_threshold', with: 10
      fill_in 'Percentage Off', with: 20
      click_on 'Create Bulk discount'
    end
    expect(current_path).to eq(merchant_bulk_discounts_path(merchant))
    bulk_discount = merchant.bulk_discounts.first
    expect(page).to have_content(bulk_discount.title)
  end
  it 'returns error messages if form is invalid' do
    merchant = Merchant.create!(name: 'I am the merchant')
    visit new_merchant_bulk_discount_path(merchant)

    within '.new-form' do
      fill_in 'Title', with: nil
      fill_in 'bulk_discount_qty_threshold', with: nil
      fill_in 'Percentage Off', with: 100
      click_on 'Create Bulk discount'

      expect(current_path).to eq(merchant_bulk_discounts_path(merchant))
    end
    within '.error-msgs' do
      expect(page).to have_content("Title can't be blank")
      expect(page).to have_content("Qty threshold can't be blank")
      expect(page).to have_content('Percentage must be less than 100')
    end
  end
end
