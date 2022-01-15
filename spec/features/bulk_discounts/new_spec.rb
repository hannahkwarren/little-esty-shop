require 'rails_helper'

RSpec.describe "New Bulk Discount page" do
  it "has a form to create a new discount and redirects back to index page" do
    merch_1 = Merchant.create!(name: 'merchant1')

    visit "/merchants/#{merch_1.id}/bulk_discounts/new"

    within ".new_discount_form" do
      fill_in "Name", with: "BOGO"
      fill_in "Discount", with: 20
      fill_in "Threshold", with: 10

      save_and_open_page
      click_button "Submit"
      expect(current_path).to eq("/merchants/#{merch_1.id}/bulk_discounts")
      # expect(page).to have_content("BOGO")
    end
  end
end
