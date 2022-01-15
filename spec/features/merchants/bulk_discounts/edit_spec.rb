require 'rails_helper'

RSpec.describe 'edit page for bulk discount' do
  it 'has a form prepulated with discount attribtues to edit' do
    merchant = Merchant.create!(name: 'I am the merchant')
    discount_1 = merchant.bulk_discounts.create!(title: 'A', qty_threshold: 10, percentage: 90)

    visit edit_merchant_bulk_discount_path(merchant, discount_1)
    within '.edit-form' do
      fill_in 'bulk_discount_title', with: 'best discount'
      fill_in 'bulk_discount_qty_threshold', with: 12
      fill_in 'bulk_discount_qty_threshold', with: 90
      click_on 'Update Bulk discount'
      expect(current_path).to eq(merchant_bulk_discount_path(merchant, discount_1))
    end
    save_and_open_page
    within '.bulk-discount' do
      discount_1.reload
      expect(page).to have_content("Bulk Discount - #{discount_1.title}")
      expect(page).to have_content("Must Purchase #{discount_1.qty_threshold} items to qualify")
      expect(page).to have_content("Percentage off: #{discount_1.percentage.to_s.concat('%')}")
    end
  end
end
