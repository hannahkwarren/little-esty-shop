require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to :invoice }
    it { should belong_to :item }
  end

  RSpec.shared_context 'common2' do 

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
            
      @invoice_1 = Invoice.create!(customer_id: @cust_1.id, status:1)
      @invoice_2 = Invoice.create!(customer_id: @cust_2.id, status:1)
      
      @bulk_discount_1 = BulkDiscount.create!(merchant_id: @merch_1.id, percentage: 15, quantity:20)
      @bulk_discount_2 = BulkDiscount.create!(merchant_id: @merch_1.id, percentage: 10, quantity:10)
      @bulk_discount_3 = BulkDiscount.create!(merchant_id:@merch_2.id, percentage: 20, quantity: 6)
    end
  end

  describe "InvoiceItem price calculations - NOTE InvoiceItem already has just one merchant" do
  
    include_context 'common2'

    it "reflects no discounted revenue when quantity threshold unmet" do
      invoice_item_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, status: 1, quantity:1, unit_price:6000)
      invoice_item_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, status: 1, quantity:1, unit_price:10000)
     
      expect(invoice_item_1.regular_price).to eq(6000)
      expect(invoice_item_1.applicable_discount).to eq(nil)
      expect(invoice_item_1.discounted_price).to eq(6000)

      expect(invoice_item_2.regular_price).to eq(10000)
      expect(invoice_item_2.applicable_discount).to eq(nil)
      expect(invoice_item_2.discounted_price).to eq(10000)
    end

    it "reflects no discounted revenue when quantity threshold unmet, regardless of merchant" do 
      invoice_item_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, status: 2, quantity:1, unit_price:6000)
      invoice_item_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_3.id, status: 2, quantity:1, unit_price:250)

      expect(invoice_item_1.regular_price).to eq(6000)
      expect(invoice_item_1.applicable_discount).to eq(nil)
      expect(invoice_item_1.discounted_price).to eq(6000)

      expect(invoice_item_2.regular_price).to eq(250)
      expect(invoice_item_2.applicable_discount).to eq(nil)
      expect(invoice_item_2.discounted_price).to eq(250)
    end

    it "reflects one discount applicable for an invoice_item which meets quantity threshold" do 
      invoice_item_3 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, status: 2, quantity:10, unit_price:10000)

      expect(invoice_item_3.regular_price).to eq(100000)
      expect(invoice_item_3.applicable_discount.percentage).to eq(10)
      expect(invoice_item_3.discounted_price).to eq(90000)
    end

    it "reflects that the best discount applies" do
      invoice_item_4 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, status: 2, quantity:20, unit_price:6000)
      invoice_item_5 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_2.id, status: 2, quantity:20, unit_price:10000)

      expect(invoice_item_4.regular_price).to eq(120000)
      expect(invoice_item_4.applicable_discount.percentage).to eq(15)
      expect(invoice_item_4.discounted_price).to eq(102000)

      expect(invoice_item_5.regular_price).to eq(200000)
      expect(invoice_item_5.applicable_discount.percentage).to eq(15)
      expect(invoice_item_5.discounted_price).to eq(170000)
    end

    it "reflects no discounts when a merchant hasn't created any bulk discounts" do 
      invoice_item_6 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_5.id, status: 2, quantity:20, unit_price:10000)

      expect(invoice_item_6.regular_price).to eq(200000)
      expect(invoice_item_6.applicable_discount).to eq(nil)
      expect(invoice_item_6.discounted_price).to eq(200000)
    end
  end
end
