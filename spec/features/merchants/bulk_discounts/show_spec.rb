require 'rails_helper'

RSpec.describe "Merchant Bulk Discount Show page", type: :feature do 

  it "has bulk discount's quantity threshold and percentage discount" do 

    merch_1 = Merchant.create!(name: "Handmade by Hannah")

    item_1 = Item.create!(name:"Sleepy Robot Mug", description:"For coffee. Lots of coffee.", unit_price:6000, merchant_id: merch_1.id)
    item_2 = Item.create!(name:"Serving Bowl", description:"More attractive to put on the dinner table.", unit_price:10000, merchant_id:merch_1.id)

    merch_2 = Merchant.create!(name: "Target")

    item_3 = Item.create!(name:"Boring White Mug", description: "Minimal, textureless white glaze.", unit_price:250, merchant_id: merch_2.id)
    item_4 = Item.create!(name:"Boring White Serving Bowl", description: "Only slightly more attractive for the dinner table.", unit_price:500, merchant_id: merch_2.id)

    bulk_discount_1 = BulkDiscount.create!(merchant_id: merch_1.id, percentage: 15, quantity:20)
    bulk_discount_2 = BulkDiscount.create!(merchant_id: merch_1.id, percentage: 10, quantity:10)
    bulk_discount_3 = BulkDiscount.create!(merchant_id: merch_2.id, percentage: 20, quantity: 6)

    visit merchant_bulk_discount_path(merch_1, bulk_discount_1)

    expect(page).to have_content("Percentage: #{bulk_discount_1.percentage}")
    expect(page).to have_content("Quantity Threshold: #{bulk_discount_1.quantity}")

  end

end
