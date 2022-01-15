require 'rails_helper'

RSpec.describe "New Bulk Discount page" do
  it "has a form to create a new discount and redirects back to index page" do
    merch_1 = Merchant.create!(name: 'merchant1')

    visit "/merchants/#{merch_1.id}/bulk_discounts/new"

    fill_in "Name", with: 'Buy Bulk!'
    fill_in "Percentage", with: 20
    fill_in "Threshold", with: 10

    click_button "Submit"
    expect(current_path).to eq("/merchants/#{merch_1.id}/bulk_discounts")
    expect(page).to have_link('Buy Bulk!')
    expect(page).to have_content('%20')
    expect(page).to have_content(10)
  end
end
