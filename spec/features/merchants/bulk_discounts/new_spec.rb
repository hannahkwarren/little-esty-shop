require 'rails_helper'

RSpec.describe "Bulk Discounts New page", type: :feature do 

  it "has a form to add a new bulk discount for a merchant, redirects to the bulk discount index when create is complete" do

    merch_1 = Merchant.create!(name: "Handmade by Hannah")

    item_1 = Item.create!(name:"Sleepy Robot Mug", description:"For coffee. Lots of coffee.", unit_price:6000, merchant_id: merch_1.id)
    item_2 = Item.create!(name:"Serving Bowl", description:"More attractive to put on the dinner table.", unit_price:10000, merchant_id:merch_1.id)

    merch_2 = Merchant.create!(name: "Target")

    item_3 = Item.create!(name:"Boring White Mug", description: "Minimal, textureless white glaze.", unit_price:250, merchant_id: merch_2.id)
    item_4 = Item.create!(name:"Boring White Serving Bowl", description: "Only slightly more attractive for the dinner table.", unit_price:500, merchant_id: merch_2.id)

    bulk_discount_1 = BulkDiscount.create!(merchant_id: merch_1.id, percentage: 15, quantity:20)
    bulk_discount_2 = BulkDiscount.create!(merchant_id: merch_1.id, percentage: 10, quantity:10)
    bulk_discount_3 = BulkDiscount.create!(merchant_id: merch_2.id, percentage: 20, quantity: 6)

    visit new_merchant_bulk_discount_path(merch_2)
    
    fill_in "Percentage Discount", with: 25
    fill_in "Quantity", with: 12

    click_button "Create Bulk Discount"

    expect(current_path).to eq(merchant_bulk_discounts_path(merch_2))

  end

end
