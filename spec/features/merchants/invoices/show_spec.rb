require 'rails_helper'

RSpec.describe 'merchant invoices show page' do

  it 'visits merchant inoice show page and displays information for that invoice' do

    merchant = Merchant.create!(name: 'merchant name')
    customer = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
    invoice = Invoice.create!(customer_id: customer.id, status: 'completed')

    visit merchant_invoice_path(merchant, invoice)

    within '.header' do
      expect(page).to have_content(invoice.id)
      expect(page).to have_content(invoice.status)
      expect(page).to have_content(invoice.created_at.strftime("%A %B %d %Y"))
      expect(page).to have_content(customer.first_name)
      expect(page).to have_content(customer.last_name)
    end
  end

  it 'lists items for an invoice and their attributes' do
    merchant = Merchant.create!(name: 'merchant name')
    not_included_merchant = Merchant.create!(name: 'merchant name')
    customer = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
    item_1 = Item.create!(merchant_id: merchant.id, name: 'widget-1', description: 'widget description', unit_price: 100)
    item_2 = Item.create!(merchant_id: merchant.id, name: 'widget-2', description: 'widget description', unit_price: 200)
    item_3 = Item.create!(merchant_id: merchant.id, name: 'widget-3', description: 'widget description', unit_price: 300)
    item_4 = Item.create!(merchant_id: merchant.id, name: 'widget-4', description: 'widget description', unit_price: 400)
    item_5 = Item.create!(merchant_id: not_included_merchant.id, name: 'widget-20', description: 'widget description', unit_price: 40440)

    invoice = Invoice.create!(customer_id: customer.id, status: 'completed')
    invoice_2 = Invoice.create!(customer_id: customer.id, status: 'completed')
    invoice_item_1 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_1.id, quantity: 7, unit_price: 100)
    invoice_item_2 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_2.id, quantity: 3, unit_price: 200)
    invoice_item_3 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_3.id, quantity: 2, unit_price: 300)
    invoice_item_4 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_4.id, quantity: 2,unit_price: 400)

    invoice_item_5 = InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_5.id, quantity: 1, unit_price: 700)

    visit merchant_invoice_path(merchant, invoice)

    within '.header' do
      expect(page).to have_content("Invoice ##{invoice.id}")
    end

    within '.invoice-items' do
      expect(page).to have_content(item_1.name)
      expect(page).to have_content(item_2.name)
      expect(page).to have_content(item_3.name)
      expect(page).to have_content(item_4.name)
      expect(page).to have_content((item_1.unit_price / 100.to_f).to_s.prepend('$').ljust(5, '0'))
      expect(page).to have_content((item_2.unit_price / 100.to_f).to_s.prepend('$').ljust(5, '0'))
      expect(page).to have_content((item_3.unit_price / 100.to_f).to_s.prepend('$').ljust(5, '0'))
      expect(page).to have_content((item_4.unit_price / 100.to_f).to_s.prepend('$').ljust(5, '0'))
      expect(page).to have_content(invoice_item_1.status)
      expect(page).to have_content(invoice_item_2.status)
      expect(page).to have_content(invoice_item_3.status)
      expect(page).to have_content(invoice_item_4.status)
      expect(page).to_not have_content(item_5.name)
    end
  end

  it 'lists the total revenue for the invoice' do
    merchant = Merchant.create!(name: 'merchant name')
    not_included_merchant = Merchant.create!(name: 'merchant name')
    customer = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
    invoice = Invoice.create!(customer_id: customer.id, status: 'completed')
    invoice_2 = Invoice.create!(customer_id: customer.id, status: 'completed')
    item_1 = Item.create!(merchant_id: merchant.id, name: 'widget-1', description: 'widget description', unit_price: 13635)
    item_2 = Item.create!(merchant_id: merchant.id, name: 'widget-2', description: 'widget description', unit_price: 23324)
    item_3 = Item.create!(merchant_id: merchant.id, name: 'widget-3', description: 'widget description', unit_price: 34873)
    item_4 = Item.create!(merchant_id: merchant.id, name: 'widget-4', description: 'widget description', unit_price: 2196)
    item_5 = Item.create!(merchant_id: not_included_merchant.id, name: 'widget-20', description: 'widget description', unit_price: 79140)
    invoice_item_1 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_1.id, quantity: 7, unit_price: 13635)
    invoice_item_2 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_2.id, quantity: 3, unit_price: 23324)
    invoice_item_3 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_3.id, quantity: 2, unit_price: 34873)
    invoice_item_4 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_4.id, quantity: 2, unit_price: 2196)

    invoice_item_5 = InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_5.id, quantity: 1, unit_price: 79140)

    visit merchant_invoice_path(merchant, invoice)

    within '.revenue' do
      expect(page). to have_content("Total Revenue: #{(invoice.total_revenue / 100.to_f).to_s.prepend('$').insert(2, ',')}")
    end
  end

  it 'allows merchant to update an invoice_item status' do
    merchant = Merchant.create!(name: 'merchant name')
    not_included_merchant = Merchant.create!(name: 'merchant name')
    customer = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
    invoice = Invoice.create!(customer_id: customer.id, status: 'completed')
    invoice_2 = Invoice.create!(customer_id: customer.id, status: 'completed')
    item_1 = Item.create!(merchant_id: merchant.id, name: 'widget-1', description: 'widget description', unit_price: 13635)
    item_2 = Item.create!(merchant_id: merchant.id, name: 'widget-2', description: 'widget description', unit_price: 23324)
    item_3 = Item.create!(merchant_id: merchant.id, name: 'widget-3', description: 'widget description', unit_price: 34873)
    item_4 = Item.create!(merchant_id: merchant.id, name: 'widget-4', description: 'widget description', unit_price: 2196)
    item_5 = Item.create!(merchant_id: not_included_merchant.id, name: 'widget-20', description: 'widget description', unit_price: 79140)
    invoice_item_1 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_1.id, quantity: 7, unit_price: 13635)
    invoice_item_2 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_2.id, quantity: 3, unit_price: 23324)
    invoice_item_3 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_3.id, quantity: 2, unit_price: 34873)
    invoice_item_4 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_4.id, quantity: 2, unit_price: 2196)
    invoice_item_5 = InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_5.id, quantity: 1, unit_price: 79140)

    visit merchant_invoice_path(merchant, invoice)
    within ".invoice-item-#{invoice_item_1.id}" do
      select("shipped", from: 'invoice_item_status')
      click_button "Update Invoice item"

      invoice_item_1.reload

      expect(invoice_item_1.status).to eq("shipped")
    end
  end

  RSpec.shared_context 'common' do 
    before do
      @merch_1 = Merchant.create!(name: "Handmade by Hannah")
      @item_1 = Item.create!(name:"Sleepy Robot Mug", description:"For coffee. Lots of coffee.", unit_price:6000, merchant_id: @merch_1.id)
      @item_2 = Item.create!(name:"Serving Bowl", description:"More attractive to put on the dinner table.", unit_price:10000, merchant_id: @merch_1.id)

      @merch_2 = Merchant.create!(name: "Target")
      @item_3 = Item.create!(name:"Boring White Mug", description: "Minimal, textureless white glaze.", unit_price:250, merchant_id: @merch_2.id)
      
      @merch_3 = Merchant.create!(name: "Expensive Imports Store")
      @item_4 = Item.create!(name:"Boring White Mug", description: "Minimal, textureless white glaze.", unit_price:500, merchant_id: @merch_3.id)

      @cust_1 = Customer.create!(first_name:"Kimmy", last_name:"Gibbler")
      @cust_2 = Customer.create!(first_name:"Bob", last_name:"Sagget")
      @cust_3 = Customer.create!(first_name:"Uncle", last_name:"Dave")
      
      @invoice_1 = Invoice.create!(customer_id: @cust_1.id, status:2)
      @invoice_2 = Invoice.create!(customer_id: @cust_2.id, status:2)
      @invoice_3 = Invoice.create!(customer_id: @cust_3.id, status:2)
      
      @bulk_discount_1 = BulkDiscount.create!(merchant_id: @merch_1.id, percentage: 15, quantity:20)
      @bulk_discount_2 = BulkDiscount.create!(merchant_id: @merch_1.id, percentage: 10, quantity:10)
      @bulk_discount_3 = BulkDiscount.create!(merchant_id: @merch_2.id, percentage: 20, quantity: 6)
    end
  end

  describe "Total Discounted Revenue on the Merchant Invoice Show Page" do
    
    include_context 'common'
    
    it "displays the same number as Total Revenue if no discounts applied" do 
      @invoice_item_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, status: 2, quantity:1, unit_price:6000) #merch_1
      @invoice_item_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_3.id, status: 2, quantity:1, unit_price:250)
    
      visit merchant_invoice_path(@merch_1, @invoice_1)

      within '.revenue' do 
        expect(page).to have_content("Total Revenue: $60.00")
      end

      within ".discounted-revenue" do 
        expect(page).to have_content("Total Discounted Revenue: $60.00")
      end

      visit merchant_invoice_path(@merch_2, @invoice_1)

      within '.revenue' do 
        expect(page).to have_content("Total Revenue: $2.50")
      end
      
      within ".discounted-revenue" do 
        expect(page).to have_content("Total Discounted Revenue: $2.50")
      end
    end

    it "displays discounted revenue only taking into account discounts on the items which met a quantity threshold" do
      invoice_item_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, status: 2, quantity:10, unit_price:6000)
      invoice_item_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, status: 2, quantity:1, unit_price:10000)

      visit merchant_invoice_path(@merch_1, @invoice_1)

      within ".revenue" do 
        expect(page).to have_content("Total Revenue: $700.00")
      end

      within ".discounted-revenue" do 
        expect(page).to have_content("Total Discounted Revenue: $640.00")
      end
    end

    it "displays correct discounted revenue (using highest applicable percentage) when all items on an invoice meet a quantity threshold" do 
      
      invoice_item_5 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, status: 2, quantity:20, unit_price:6000)
      invoice_item_6 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_2.id, status: 2, quantity:10, unit_price:10000)

      visit merchant_invoice_path(@merch_1, @invoice_2)

      within ".revenue" do 
        expect(page).to have_content("Total Revenue: $2,200.00")
      end

      within ".discounted-revenue" do 
        expect(page).to have_content("Total Discounted Revenue: $1,920.00")
      end
    end

    it "displays discounted revenue as same as total revenue when a merchant has no bulk discounts" do 
      invoice_item_7 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, status: 2, quantity:20, unit_price:500)
      
      visit merchant_invoice_path(@merch_3, @invoice_3)

      within ".revenue" do 
        expect(page).to have_content("Total Revenue: $100.00")
      end

      within '.discounted-revenue' do 
        expect(page).to have_content("Total Discounted Revenue: $100.00")
      end
    end

    it "has a link to the applied bulk discount, if applicable, for each invoice_item on the page" do 
      invoice_item_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, status: 2, quantity:10, unit_price:6000)
      invoice_item_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, status: 2, quantity:1, unit_price:10000)

      visit merchant_invoice_path(@merch_1, @invoice_1)

      within ".invoice-items" do 
        expect(page).to have_link("Bulk Discount")
      end
      
      click_link("Bulk Discount")

      expect(current_path).to eq(merchant_bulk_discount_path(@merch_1, @bulk_discount_2))
    end
  end

end
