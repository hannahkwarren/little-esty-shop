require 'rails_helper'

RSpec.describe Invoice, type: :model do

  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should have_many(:invoice_items) }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe '#merchants_invoices' do
    it "returns merchants invoices" do
      merch_1 = Merchant.create!(name: "Shop Here")

      item_1 = Item.create!(name:"jumprope", description:"Pink and sparkly.", unit_price:600, merchant_id:"#{merch_1.id}")
      item_2 = Item.create!(name:"hula hoop", description:"Get your groove on!", unit_price:700, merchant_id:"#{merch_1.id}")

      cust_1 = Customer.create!(first_name:"Hannah", last_name:"Warner")

      invoice_1 = Invoice.create!(customer_id:"#{cust_1.id}", status:1)
      invoice_2 = Invoice.create!(customer_id:"#{cust_1.id}", status:1)
      invoice_3 = Invoice.create!(customer_id:"#{cust_1.id}", status:1)

      invoice_item_1 = InvoiceItem.create!(invoice_id:"#{invoice_1.id}", item_id:"#{item_1.id}", status: 2, quantity:1, unit_price:600)
      invoice_item_2 = InvoiceItem.create!(invoice_id:"#{invoice_2.id}", item_id:"#{item_2.id}", status: 2, quantity:1, unit_price:700)
      invoice_item_3 = InvoiceItem.create!(invoice_id:"#{invoice_3.id}", item_id:"#{item_2.id}", status: 2, quantity:1, unit_price:700)
      invoice_item_4 = InvoiceItem.create!(invoice_id:"#{invoice_1.id}", item_id:"#{item_1.id}", status: 2, quantity:1, unit_price:600)

      expect(Invoice.merchants_invoices(merch_1)).to contain_exactly(invoice_1, invoice_2, invoice_3)
    end
  end

  describe '#total_revenue' do
    it 'returns total revenue for an invoice' do
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
      invoice_item_4 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_4.id, quantity: 2, unit_price: 400)
      invoice_item_5 = InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_5.id, quantity: 1, unit_price: 700)

      actual = invoice.total_revenue
      expected = 2700

      expect(actual).to eq(expected)
    end
  end

  describe '#incomplete_invoices' do
    it "returns incomplete invoices" do
      cust_1 = Customer.create!(first_name:"Hannah", last_name:"Warner")

      invoice_1 = Invoice.create!(customer_id:"#{cust_1.id}", status: "in progress")
      invoice_2 = Invoice.create!(customer_id:"#{cust_1.id}", status:"completed")
      invoice_3 = Invoice.create!(customer_id:"#{cust_1.id}", status:"in progress", created_at:DateTime.yesterday)

      expect(Invoice.incomplete_invoices.to_a).to eq([invoice_3, invoice_1])
    end
  end

  RSpec.shared_context 'common3' do 

    before do 
      @merch_1 = Merchant.create!(name: "Handmade by Hannah")
      @item_1 = Item.create!(name:"Sleepy Robot Mug", description:"For coffee. Lots of coffee.", unit_price:6000, merchant_id: @merch_1.id)
      @item_2 = Item.create!(name:"Serving Bowl", description:"More attractive to put on the dinner table.", unit_price:10000, merchant_id:@merch_1.id)

      @merch_2 = Merchant.create!(name: "Target")
      @item_3 = Item.create!(name:"Boring White Mug", description: "Minimal, textureless white glaze.", unit_price:250, merchant_id: @merch_2.id)
      @item_4 = Item.create!(name:"Boring White Serving Bowl", description: "Only slightly more attractive for the dinner table.", unit_price:500, merchant_id: @merch_2.id)

      @merch_3 = Merchant.create!(name: "Expensive Imports Store")
      @item_5 = Item.create!(name:"Boring White Mug", description: "Minimal, textureless white glaze.", unit_price:500, merchant_id: @merch_3.id)

      @cust_1 = Customer.create!(first_name:"Kimmy", last_name:"Gibbler")
      @cust_2 = Customer.create!(first_name:"Bob", last_name:"Sagget")
      @cust_3 = Customer.create!(first_name:"Uncle", last_name:"Dave")
      @cust_4 = Customer.create!(first_name:"Avery", last_name:"Kirsch")
      
      @invoice_1 = Invoice.create!(customer_id: @cust_1.id, status:1)
      @invoice_2 = Invoice.create!(customer_id: @cust_2.id, status:1)
      @invoice_3 = Invoice.create!(customer_id: @cust_3.id, status:1)
      @invoice_4 = Invoice.create!(customer_id: @cust_4.id, status:1)
      @invoice_5 = Invoice.create!(customer_id: @cust_1.id, status:1)

      @bulk_discount_1 = BulkDiscount.create!(merchant_id: @merch_1.id, percentage: 15, quantity:20)
      @bulk_discount_2 = BulkDiscount.create!(merchant_id: @merch_1.id, percentage: 10, quantity:10)
      @bulk_discount_3 = BulkDiscount.create!(merchant_id:@merch_2.id, percentage: 20, quantity: 6)
    end
  end

  describe '#total_discounted_revenue' do 

    include_context 'common3'

    it "reflects no discounted revenue when quantity threshold unmet" do
      invoice_item_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, status: 1, quantity:1, unit_price:6000)
      invoice_item_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, status: 1, quantity:1, unit_price:10000)
     
      expect(@invoice_1.total_discounted_revenue(@merch_1)).to eq(@invoice_1.total_revenue(@merch_1))
    end

    it "reflects no discounted revenue when quantity threshold unmet, more than one merchant on an invoice" do 
      invoice_item_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, status: 2, quantity:1, unit_price:6000)
      invoice_item_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_3.id, status: 2, quantity:1, unit_price:250)

      #for merchant invoice show view - revenue is specific to a merchant
      expect(@invoice_1.total_discounted_revenue(@merch_1)).to eq(@invoice_1.total_revenue(@merch_1))
      expect(@invoice_1.total_discounted_revenue(@merch_2)).to eq(@invoice_1.total_revenue(@merch_2))

      #without taking a merchant into account
      expect(@invoice_1.total_discounted_revenue).to eq(@invoice_1.total_revenue)
    end

    it "reflects one discount applicable for only one item which meets quantity threshold - all items in invoice from one merchant" do 
      invoice_item_3 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, status: 2, quantity:1, unit_price:6000)
      invoice_item_4 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, status: 2, quantity:10, unit_price:10000)

      expect(@invoice_1.total_discounted_revenue(@merch_1)).to eq(96000)
      expect(@invoice_1.total_revenue(@merch_1)).to eq(106000)
    end

    it "reflects that when numerous items meet the higher quantity threshold, they only receive the best discount - all items from one merchant" do 
      invoice_item_5 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, status: 2, quantity:20, unit_price:6000)
      invoice_item_6 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_2.id, status: 2, quantity:22, unit_price:10000)

      expect(@invoice_2.total_discounted_revenue(@merch_1)).to eq(289000)
      expect(@invoice_2.total_revenue(@merch_1)).to eq(340000)
    end

    it "reflects only applicable discounts on one merchant's items, and not the other - when items from more than one merchant are on a single invoice" do 
    
      invoice_item_7 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_1.id, status: 2, quantity:5, unit_price:6000)
      invoice_item_8 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_3.id, status: 2, quantity:20, unit_price:250)
      invoice_item_9 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_2.id, status: 2, quantity:20, unit_price:10000)

      expect(@invoice_3.total_discounted_revenue(@merch_2)).to eq(4000)
      expect(@invoice_3.total_revenue(@merch_2)).to eq(5000)

      expect(@invoice_3.total_discounted_revenue(@merch_1)).to eq(200000)
      expect(@invoice_3.total_revenue(@merch_1)).to eq(230000)

      expect(@invoice_3.total_discounted_revenue).to eq(204000)
      expect(@invoice_3.total_revenue).to eq(235000)
    end

  end
end
