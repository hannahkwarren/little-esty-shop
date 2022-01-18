require 'rails_helper'

RSpec.describe "Merchant Bulk Discounts Index page", type: :feature do 
  
  it "has each bulk discount along with its percentage and quantity specifications + each links to respective bulk discount show page" do 
    merch_1 = Merchant.create!(name: "Handmade by Hannah")

    item_1 = Item.create!(name:"Sleepy Robot Mug", description:"For coffee. Lots of coffee.", unit_price:6000, merchant_id: merch_1.id)
    item_2 = Item.create!(name:"Serving Bowl", description:"More attractive to put on the dinner table.", unit_price:10000, merchant_id:merch_1.id)

    merch_2 = Merchant.create!(name: "Target")

    item_3 = Item.create!(name:"Boring White Mug", description: "Minimal, textureless white glaze.", unit_price:250, merchant_id: merch_2.id)
    item_4 = Item.create!(name:"Boring White Serving Bowl", description: "Only slightly more attractive for the dinner table.", unit_price:500, merchant_id: merch_2.id)

    bulk_discount_1 = BulkDiscount.create!(merchant_id: merch_1.id, percentage: 15, quantity:20)
    bulk_discount_2 = BulkDiscount.create!(merchant_id: merch_1.id, percentage: 10, quantity:10)
    bulk_discount_3 = BulkDiscount.create!(merchant_id: merch_2.id, percentage: 20, quantity: 6)

    visit merchant_bulk_discounts_path(merch_1) 

    within ".bulk-discount-#{bulk_discount_1.id}" do
      expect(page).to have_content("Bulk Discount, ID: #{bulk_discount_1.id}")
      expect(page).to have_content("Percentage: #{bulk_discount_1.percentage}")
      expect(page).to have_content("Quantity Threshold: #{bulk_discount_1.quantity}")
    end

    within ".bulk-discount-#{bulk_discount_2.id}" do
      expect(page).to have_content("Bulk Discount, ID: #{bulk_discount_2.id}")
      expect(page).to have_content("Percentage: #{bulk_discount_2.percentage}")
      expect(page).to have_content("Quantity Threshold: #{bulk_discount_2.quantity}")
    end

    expect(page).to_not have_content("Bulk Discount, ID: #{bulk_discount_3}")

    click_link "Bulk Discount, ID: #{bulk_discount_1.id}"

    expect(current_path).to eq("/merchants/#{merch_1.id}/bulk_discounts/#{bulk_discount_1.id}")
  end

  it "has a link to go to the new form and create a new bulk discount" do 
    merch_1 = Merchant.create!(name: "Handmade by Hannah")

    item_1 = Item.create!(name:"Sleepy Robot Mug", description:"For coffee. Lots of coffee.", unit_price:6000, merchant_id: merch_1.id)
    item_2 = Item.create!(name:"Serving Bowl", description:"More attractive to put on the dinner table.", unit_price:10000, merchant_id:merch_1.id)

    merch_2 = Merchant.create!(name: "Target")

    item_3 = Item.create!(name:"Boring White Mug", description: "Minimal, textureless white glaze.", unit_price:250, merchant_id: merch_2.id)
    item_4 = Item.create!(name:"Boring White Serving Bowl", description: "Only slightly more attractive for the dinner table.", unit_price:500, merchant_id: merch_2.id)

    bulk_discount_1 = BulkDiscount.create!(merchant_id: merch_1.id, percentage: 15, quantity:20)
    bulk_discount_2 = BulkDiscount.create!(merchant_id: merch_1.id, percentage: 10, quantity:10)
    bulk_discount_3 = BulkDiscount.create!(merchant_id: merch_2.id, percentage: 20, quantity: 6)

    visit merchant_bulk_discounts_path(merch_1) 

    click_link("Create New Bulk Discount")

    expect(current_path).to eq(new_merchant_bulk_discount_path(merch_1))
  end

  it "has a link under each item to delete it and redirect back to the index page" do 

    merch_1 = Merchant.create!(name: "Handmade by Hannah")

    item_1 = Item.create!(name:"Sleepy Robot Mug", description:"For coffee. Lots of coffee.", unit_price:6000, merchant_id: merch_1.id)
    item_2 = Item.create!(name:"Serving Bowl", description:"More attractive to put on the dinner table.", unit_price:10000, merchant_id:merch_1.id)

    merch_2 = Merchant.create!(name: "Target")

    item_3 = Item.create!(name:"Boring White Mug", description: "Minimal, textureless white glaze.", unit_price:250, merchant_id: merch_2.id)
    item_4 = Item.create!(name:"Boring White Serving Bowl", description: "Only slightly more attractive for the dinner table.", unit_price:500, merchant_id: merch_2.id)

    bulk_discount_1 = BulkDiscount.create!(merchant_id: merch_1.id, percentage: 15, quantity:20)
    bulk_discount_2 = BulkDiscount.create!(merchant_id: merch_1.id, percentage: 10, quantity:10)
    bulk_discount_3 = BulkDiscount.create!(merchant_id: merch_2.id, percentage: 20, quantity: 6)

    visit merchant_bulk_discounts_path(merch_1) 

    click_link("Delete Bulk Discount #{bulk_discount_2.id}")

    expect(current_path).to eq(merchant_bulk_discounts_path(merch_1))
    expect(page).to_not have_content("Bulk Discount, ID: #{bulk_discount_2.id}")
  end

  it "has a section with next 3 upcoming US holidays listed" do 
    merch_1 = Merchant.create!(name: "Handmade by Hannah")

    item_1 = Item.create!(name:"Sleepy Robot Mug", description:"For coffee. Lots of coffee.", unit_price:6000, merchant_id: merch_1.id)
    item_2 = Item.create!(name:"Serving Bowl", description:"More attractive to put on the dinner table.", unit_price:10000, merchant_id:merch_1.id)

    merch_2 = Merchant.create!(name: "Target")

    item_3 = Item.create!(name:"Boring White Mug", description: "Minimal, textureless white glaze.", unit_price:250, merchant_id: merch_2.id)
    item_4 = Item.create!(name:"Boring White Serving Bowl", description: "Only slightly more attractive for the dinner table.", unit_price:500, merchant_id: merch_2.id)

    bulk_discount_1 = BulkDiscount.create!(merchant_id: merch_1.id, percentage: 15, quantity:20)
    bulk_discount_2 = BulkDiscount.create!(merchant_id: merch_1.id, percentage: 10, quantity:10)
    bulk_discount_3 = BulkDiscount.create!(merchant_id: merch_2.id, percentage: 20, quantity: 6)

    visit merchant_bulk_discounts_path(merch_1)

    within ".us-holidays" do 
      expect(page).to have_content("Monday, February 21, 2022")
      expect(page).to have_content("Friday, April 15, 2022")
      expect(page).to have_content("Monday, May 30, 2022")
    end
    save_and_open_page
  end

end
