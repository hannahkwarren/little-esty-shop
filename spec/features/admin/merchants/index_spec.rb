require 'rails_helper'

RSpec.describe "Admin Merchants Index Page", type: :feature do

  it "has the names of each merchant in the system" do
    merch_1 = Merchant.create!(name: "Easily Amused Studio")
    merch_2 = Merchant.create!(name: "Retro Furniture")
    merch_3 = Merchant.create!(name: "Vintage Accessories")

    visit "/admin/merchants"

    expect(page).to have_content("Easily Amused Studio")
    expect(page).to have_content("Retro Furniture")
    expect(page).to have_content("Vintage Accessories")
  end

  it "names are links; when clicked, current path is that merchant's show page" do
    merch_1 = Merchant.create!(name: "Easily Amused Studio")
    merch_2 = Merchant.create!(name: "Retro Furniture")
    merch_3 = Merchant.create!(name: "Vintage Accessories")

    visit "/admin/merchants"

    click_link("Easily Amused Studio")

    expect(current_path).to eq("/admin/merchants/#{merch_1.id}")
  end

  it "has a link to create a new merchant at /admin/merchants/new" do

    visit admin_merchants_path

    within ".new_merchant" do
      expect(page).to have_content("Create Merchant")
      click_link("Create Merchant")
    end

    expect(current_path).to eq(new_admin_merchant_path)
  end

  it "lists merchants in correct section: enabled or disabled" do
    merch_1 = Merchant.create!(name: "Easily Amused Studio", status: 1)
    merch_2 = Merchant.create!(name: "Retro Furniture")
    merch_3 = Merchant.create!(name: "Vintage Accessories")

    visit "/admin/merchants"

    within ".enabled_merchants" do
      expect(page).to have_content(merch_1.name)
    end

    within ".disabled_merchants" do
      expect(page).to have_content(merch_2.name)
      expect(page).to have_content(merch_3.name)
    end
  end

  it "has a link next to each merchant name for enabling or disabling that merchant" do
    merch_1 = Merchant.create!(name: "Easily Amused Studio", status: 1)
    merch_2 = Merchant.create!(name: "Retro Furniture")
    merch_3 = Merchant.create!(name: "Vintage Accessories")

    visit "/admin/merchants"

    within ".enabled_merchants" do
      expect(page).to have_selector(:link_or_button, 'Disable Easily Amused Studio')
    end

    within ".disabled_merchants" do
      expect(page).to have_selector(:link_or_button, 'Enable Retro Furniture')
      expect(page).to have_selector(:link_or_button, 'Enable Vintage Accessories')
    end

    click_button "Enable #{merch_3.name}"

    within ".enabled_merchants" do
      expect(page).to have_selector(:link_or_button, "Disable #{merch_1.name}")
      expect(page).to have_selector(:link_or_button, "Disable #{merch_3.name}")
    end

    within ".disabled_merchants" do
      expect(page).to have_selector(:link_or_button, "Enable #{merch_2.name}")
    end
  end

  it "lists top 5 merchants by revenue" do

    merch_1 = Merchant.create!(name: "Shop Here", status: 1)
    merch_2 = Merchant.create!(name: "Handmade by Hannah", status: 1)
    merch_3 = Merchant.create!(name: "Polymer Clay Sculpture", status: 1)
    merch_4 = Merchant.create!(name: "Curiosities", status: 1)
    merch_5 = Merchant.create!(name: "Modern Vintage", status: 1)
    merch_6 = Merchant.create!(name: "Haberdashery", status: 1)

    item_1 = Item.create!(name:"Sleepy Robot Mug", description:"For coffee. Lots of coffee.", unit_price:600, merchant_id:"#{merch_2.id}")
    item_2 = Item.create!(name:"Foxes under a tree", description:"Something joyful to look at.", unit_price:600, merchant_id:"#{merch_3.id}")
    item_3 = Item.create!(name:"Antique Egg Whisk", description:"What even is this thing?!", unit_price:600, merchant_id:"#{merch_4.id}")
    item_4 = Item.create!(name:"A-line Dress", description:"Universally flattering.", unit_price:600, merchant_id:"#{merch_5.id}")
    item_5 = Item.create!(name:"Top Hat", description:"Embrace the steam punk.", unit_price:600, merchant_id:"#{merch_6.id}")

    cust_1 = Customer.create!(first_name:"Hannah", last_name:"Warner")
    cust_2 = Customer.create!(first_name:"Kimmy", last_name:"Gibbler")
    cust_3 = Customer.create!(first_name:"Bob", last_name:"Sagget")
    cust_4 = Customer.create!(first_name:"Uncle", last_name:"Dave")
    cust_5 = Customer.create!(first_name:"Uncle", last_name:"Jessie")
    cust_6 = Customer.create!(first_name:"DJ", last_name:"Tanner")

    invoice_1 = Invoice.create!(customer_id:"#{cust_2.id}", status:1)
    invoice_2 = Invoice.create!(customer_id:"#{cust_3.id}", status:1)
    invoice_3 = Invoice.create!(customer_id:"#{cust_4.id}", status:1)
    invoice_4 = Invoice.create!(customer_id:"#{cust_5.id}", status:1)
    invoice_5 = Invoice.create!(customer_id:"#{cust_6.id}", status:1)

    transaction_1 = Transaction.create(invoice_id:"#{invoice_1.id}", result: "success")
    transaction_2 = Transaction.create(invoice_id:"#{invoice_2.id}", result: "success")
    transaction_3 = Transaction.create(invoice_id:"#{invoice_3.id}", result: "success")
    transaction_4 = Transaction.create(invoice_id:"#{invoice_4.id}", result: "success")
    transaction_5 = Transaction.create(invoice_id:"#{invoice_5.id}", result: "success")

    invoice_item_1 = InvoiceItem.create!(invoice_id:"#{invoice_1.id}", item_id:"#{item_1.id}", status: 1, quantity:2, unit_price:600)
    invoice_item_2 = InvoiceItem.create!(invoice_id:"#{invoice_2.id}", item_id:"#{item_2.id}", status: 1, quantity:3, unit_price:600)
    invoice_item_3 = InvoiceItem.create!(invoice_id:"#{invoice_3.id}", item_id:"#{item_3.id}", status: 2, quantity:4, unit_price:600)
    invoice_item_4 = InvoiceItem.create!(invoice_id:"#{invoice_4.id}", item_id:"#{item_4.id}", status: 2, quantity:5, unit_price:600)
    invoice_item_5 = InvoiceItem.create!(invoice_id:"#{invoice_5.id}", item_id:"#{item_5.id}", status: 2, quantity:6, unit_price:600)

    visit admin_merchants_path

    within ".top_5_merchants" do
      expect(page).to have_content("#{merch_6.name} | Total Revenue: $36.00")
      expect(page).to have_content("#{merch_5.name} | Total Revenue: $30.00")
      expect(page).to have_content("#{merch_4.name} | Total Revenue: $24.00")
      expect(page).to have_content("#{merch_3.name} | Total Revenue: $18.00")
      expect(page).to have_content("#{merch_2.name} | Total Revenue: $12.00")

      expect("#{merch_6.name}").to appear_before("#{merch_5.name}")
      expect("#{merch_5.name}").to appear_before("#{merch_4.name}")
      expect("#{merch_4.name}").to appear_before("#{merch_3.name}")
      expect("#{merch_3.name}").to appear_before("#{merch_2.name}")
      expect("#{merch_6.name}").to appear_before("#{merch_4.name}")
      expect("#{merch_6.name}").to appear_before("#{merch_3.name}")
      expect("#{merch_6.name}").to appear_before("#{merch_2.name}")
    end
  end

  it 'sees date with most revenue for each of the top 5 merchants' do
    merch_1 = Merchant.create!(name: "Shop Here", status: 1)
    merch_2 = Merchant.create!(name: "Handmade by Hannah", status: 1)
    merch_3 = Merchant.create!(name: "Polymer Clay Sculpture", status: 1)
    merch_4 = Merchant.create!(name: "Curiosities", status: 1)
    merch_5 = Merchant.create!(name: "Modern Vintage", status: 1)
    merch_6 = Merchant.create!(name: "Haberdashery", status: 1)

    item_1 = Item.create!(name:"Sleepy Robot Mug", description:"For coffee. Lots of coffee.", unit_price:600, merchant_id:"#{merch_1.id}")
    item_2 = Item.create!(name:"Foxes under a tree", description:"Something joyful to look at.", unit_price:600, merchant_id:"#{merch_2.id}")
    item_3 = Item.create!(name:"Antique Egg Whisk", description:"What even is this thing?!", unit_price:600, merchant_id:"#{merch_3.id}")
    item_4 = Item.create!(name:"A-line Dress", description:"Universally flattering.", unit_price:600, merchant_id:"#{merch_4.id}")
    item_5 = Item.create!(name:"Top Hat", description:"Embrace the steam punk.", unit_price:600, merchant_id:"#{merch_5.id}")
    item_6 = Item.create!(name:"Bottom Hat", description:"Embrace the steam punk.", unit_price:600, merchant_id:"#{merch_6.id}")

    cust_1 = Customer.create!(first_name:"Hannah", last_name:"Warner")


    invoice_1 = Invoice.create!(customer_id:"#{cust_1.id}", status:1, created_at: "2012-03-25 09:54:09")
    invoice_2 = Invoice.create!(customer_id:"#{cust_1.id}", status:1, created_at: "2012-03-24 09:54:09")
    invoice_3 = Invoice.create!(customer_id:"#{cust_1.id}", status:1, created_at: "2012-03-23 09:54:09")
    invoice_4 = Invoice.create!(customer_id:"#{cust_1.id}", status:1, created_at: "2012-03-22 09:54:09")
    invoice_5 = Invoice.create!(customer_id:"#{cust_1.id}", status:1, created_at: "2012-03-21 09:54:09")
    invoice_6 = Invoice.create!(customer_id:"#{cust_1.id}", status:1, created_at: "2012-03-20 09:54:09")

    Transaction.create(invoice_id:"#{invoice_1.id}", result: "success")
    Transaction.create(invoice_id:"#{invoice_1.id}", result: "success")
    Transaction.create(invoice_id:"#{invoice_1.id}", result: "success")

    Transaction.create(invoice_id:"#{invoice_2.id}", result: "success")
    Transaction.create(invoice_id:"#{invoice_2.id}", result: "success")

    Transaction.create(invoice_id:"#{invoice_3.id}", result: "success")
    Transaction.create(invoice_id:"#{invoice_3.id}", result: "success")

    Transaction.create(invoice_id:"#{invoice_4.id}", result: "success")
    Transaction.create(invoice_id:"#{invoice_4.id}", result: "success")

    Transaction.create(invoice_id:"#{invoice_5.id}", result: "success")
    Transaction.create(invoice_id:"#{invoice_5.id}", result: "success")

    Transaction.create(invoice_id:"#{invoice_6.id}", result: "success")


    invoice_item_1 = InvoiceItem.create!(invoice_id:"#{invoice_1.id}", item_id:"#{item_1.id}", status: 1, quantity:2, unit_price:600)
    invoice_item_2 = InvoiceItem.create!(invoice_id:"#{invoice_2.id}", item_id:"#{item_2.id}", status: 1, quantity:3, unit_price:600)
    invoice_item_3 = InvoiceItem.create!(invoice_id:"#{invoice_3.id}", item_id:"#{item_3.id}", status: 2, quantity:4, unit_price:600)
    invoice_item_4 = InvoiceItem.create!(invoice_id:"#{invoice_4.id}", item_id:"#{item_4.id}", status: 2, quantity:5, unit_price:600)
    invoice_item_5 = InvoiceItem.create!(invoice_id:"#{invoice_5.id}", item_id:"#{item_5.id}", status: 2, quantity:6, unit_price:600)
    invoice_item_6 = InvoiceItem.create!(invoice_id:"#{invoice_6.id}", item_id:"#{item_6.id}", status: 1, quantity:2, unit_price:600)

    visit admin_merchants_path

    within ".top_5_merchants" do
      expect(page).to have_content("Top day for #{merch_1.name} was #{invoice_1.created_at.strftime("%A %B %d %Y")}")
      expect(page).to have_content("Top day for #{merch_2.name} was #{invoice_2.created_at.strftime("%A %B %d %Y")}")
      expect(page).to have_content("Top day for #{merch_3.name} was #{invoice_3.created_at.strftime("%A %B %d %Y")}")
      expect(page).to have_content("Top day for #{merch_4.name} was #{invoice_4.created_at.strftime("%A %B %d %Y")}")
      expect(page).to have_content("Top day for #{merch_5.name} was #{invoice_5.created_at.strftime("%A %B %d %Y")}")
      save_and_open_page
    end

  end
end
