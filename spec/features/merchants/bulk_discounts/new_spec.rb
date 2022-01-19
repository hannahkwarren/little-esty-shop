require 'rails_helper'

RSpec.describe "Bulk Discounts New page", type: :feature do 

  it "has a form to add a new bulk discount for a merchant, redirects to the bulk discount index when create is complete" do

    merch_2 = Merchant.create!(name: "Target")

    item_3 = Item.create!(name:"Boring White Mug", description: "Minimal, textureless white glaze.", unit_price:250, merchant_id: merch_2.id)
    item_4 = Item.create!(name:"Boring White Serving Bowl", description: "Only slightly more attractive for the dinner table.", unit_price:500, merchant_id: merch_2.id)

    bulk_discount_3 = BulkDiscount.create!(merchant_id: merch_2.id, percentage: 20, quantity: 6)

    visit new_merchant_bulk_discount_path(merch_2)
    
    fill_in "Percentage Discount", with: 25
    fill_in "Quantity", with: 12

    click_button "Create Bulk Discount"

    expect(current_path).to eq(merchant_bulk_discounts_path(merch_2))
  end

  it "doesn't allow invalid (never used) discount to be created - same quantity lower percentage" do 
    merch_1 = Merchant.create!(name: "Handmade by Hannah")

    item_1 = Item.create!(name:"Sleepy Robot Mug", description:"For coffee. Lots of coffee.", unit_price:6000, merchant_id: merch_1.id)
    item_2 = Item.create!(name:"Serving Bowl", description:"More attractive to put on the dinner table.", unit_price:10000, merchant_id:merch_1.id)

    bulk_discount_1 = BulkDiscount.create!(merchant_id: merch_1.id, percentage: 15, quantity:20)
    bulk_discount_2 = BulkDiscount.create!(merchant_id: merch_1.id, percentage: 10, quantity:10)

    visit new_merchant_bulk_discount_path(merch_1)

    fill_in "Percentage Discount", with: 5
    fill_in "Quantity", with: 10

    click_button "Create Bulk Discount"
    
    expect(current_path).to eq(new_merchant_bulk_discount_path(merch_1))
    expect(page).to have_content("This discount would never be applied, or would be undercutting your profit on an existing discount. Please adjust your inputs.")
  end

  it "doesn't allow invalid (never used) discount to be created - higher quantity same percentage" do 
    merch_1 = Merchant.create!(name: "Handmade by Hannah")

    item_1 = Item.create!(name:"Sleepy Robot Mug", description:"For coffee. Lots of coffee.", unit_price:6000, merchant_id: merch_1.id)
    item_2 = Item.create!(name:"Serving Bowl", description:"More attractive to put on the dinner table.", unit_price:10000, merchant_id:merch_1.id)

    bulk_discount_1 = BulkDiscount.create!(merchant_id: merch_1.id, percentage: 15, quantity:20)
    bulk_discount_2 = BulkDiscount.create!(merchant_id: merch_1.id, percentage: 10, quantity:10)

    visit new_merchant_bulk_discount_path(merch_1)

    fill_in "Percentage Discount", with: 15
    fill_in "Quantity", with: 50

    click_button "Create Bulk Discount"
    
    expect(current_path).to eq(new_merchant_bulk_discount_path(merch_1))
    expect(page).to have_content("This discount would never be applied, or would be undercutting your profit on an existing discount. Please adjust your inputs.")
  end

  it "doesn't allow invalid (never used) discount to be created - lower quantity same percentage" do 
    merch_1 = Merchant.create!(name: "Handmade by Hannah")

    item_1 = Item.create!(name:"Sleepy Robot Mug", description:"For coffee. Lots of coffee.", unit_price:6000, merchant_id: merch_1.id)
    item_2 = Item.create!(name:"Serving Bowl", description:"More attractive to put on the dinner table.", unit_price:10000, merchant_id:merch_1.id)

    bulk_discount_1 = BulkDiscount.create!(merchant_id: merch_1.id, percentage: 15, quantity:20)
    bulk_discount_2 = BulkDiscount.create!(merchant_id: merch_1.id, percentage: 10, quantity:10)

    visit new_merchant_bulk_discount_path(merch_1)

    fill_in "Percentage Discount", with: 10
    fill_in "Quantity", with: 6

    click_button "Create Bulk Discount"
    
    expect(current_path).to eq(new_merchant_bulk_discount_path(merch_1))
    expect(page).to have_content("This discount would never be applied, or would be undercutting your profit on an existing discount. Please adjust your inputs.")
  end

  it "doesn't allow invalid (never used) discount to be created - lower quantity higher percentage" do 

    # Debateable; logically, why would a merchant set a higher percentage off for less product? The rule here is: "you can't undercut yourself with a higher discount on less product than you've already specified"

    merch_1 = Merchant.create!(name: "Handmade by Hannah")

    item_1 = Item.create!(name:"Sleepy Robot Mug", description:"For coffee. Lots of coffee.", unit_price:6000, merchant_id: merch_1.id)
    item_2 = Item.create!(name:"Serving Bowl", description:"More attractive to put on the dinner table.", unit_price:10000, merchant_id:merch_1.id)

    bulk_discount_1 = BulkDiscount.create!(merchant_id: merch_1.id, percentage: 15, quantity:20)
    bulk_discount_2 = BulkDiscount.create!(merchant_id: merch_1.id, percentage: 10, quantity:10)

    visit new_merchant_bulk_discount_path(merch_1)

    fill_in "Percentage Discount", with: 25
    fill_in "Quantity", with: 6

    click_button "Create Bulk Discount"
    
    expect(current_path).to eq(new_merchant_bulk_discount_path(merch_1))
    expect(page).to have_content("This discount would never be applied, or would be undercutting your profit on an existing discount. Please adjust your inputs.")
  end

end
