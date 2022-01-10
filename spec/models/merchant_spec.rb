require 'rails_helper'

#--- use this to see a full diff output ---
# RSpec.configure do |rspec|
#   rspec.expect_with :rspec do |c|
#   c.max_formatted_output_length = 1000 # n is number of lines, or nil for no truncation.
#   end
# end

RSpec.describe Merchant, type: :model do

  describe "relationships" do
    it {should have_many(:items) }
    it {should have_many(:invoice_items).through(:items) }
    it {should have_many(:invoices).through(:invoice_items) }
    it {should have_many(:customers).through(:invoices) }
  end


  describe "instance methods" do

    it "#merchants_invoices" do
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

      expect(merch_1.merchants_invoices).to eq([invoice_1, invoice_2, invoice_3])
    end

    it "#items_ready_to_ship" do
      merch_1 = Merchant.create!(name: "Shop Here")

      item_1 = Item.create!(name:"jumprope", description:"Pink and sparkly.", unit_price:600, merchant_id:"#{merch_1.id}")
      item_2 = Item.create!(name:"jelly shoes", description: "So 90's.", unit_price:600, merchant_id:"#{merch_1.id}")

      cust_1 = Customer.create!(first_name:"DJ", last_name:"Tanner")
      cust_2 = Customer.create!(first_name:"Kimmy", last_name:"Gibbler")

      invoice_1 = Invoice.create!(customer_id:"#{cust_1.id}", status:1)
      invoice_2 = Invoice.create!(customer_id:"#{cust_2.id}", status:1)

      invoice_item_1 = InvoiceItem.create!(invoice_id:"#{invoice_1.id}", item_id:"#{item_1.id}", status: 1, quantity:1, unit_price:600)
      invoice_item_2 = InvoiceItem.create!(invoice_id:"#{invoice_1.id}", item_id:"#{item_1.id}", status: 2, quantity:1, unit_price:600)

      expect(merch_1.items_ready_to_ship).to contain_exactly(invoice_item_1)
    end

    it "#favorite_customers - returns top 5 customers with most successful transactions" do

      merch_1 = Merchant.create!(name: "Shop Here")

      item_1 = Item.create!(name:"jumprope", description:"Pink and sparkly.", unit_price:600, merchant_id:"#{merch_1.id}")
      item_2 = Item.create!(name:"jelly shoes", description: "So 90's.", unit_price:600, merchant_id:"#{merch_1.id}")

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
      invoice_item_2 = InvoiceItem.create!(invoice_id:"#{invoice_2.id}", item_id:"#{item_1.id}", status: 1, quantity:3, unit_price:600)
      invoice_item_3 = InvoiceItem.create!(invoice_id:"#{invoice_3.id}", item_id:"#{item_1.id}", status: 2, quantity:4, unit_price:600)
      invoice_item_4 = InvoiceItem.create!(invoice_id:"#{invoice_4.id}", item_id:"#{item_1.id}", status: 2, quantity:5, unit_price:600)
      invoice_item_5 = InvoiceItem.create!(invoice_id:"#{invoice_5.id}", item_id:"#{item_1.id}", status: 2, quantity:6, unit_price:600)

      expect(merch_1.merchants_favorite_customers).to contain_exactly(cust_2, cust_3, cust_4, cust_5, cust_6)
    end
  end

  describe "class methods" do


    it ".enabled_merchants" do
      merch_1 = Merchant.create!(name: "Shop Here")
      merch_2 = Merchant.create!(name: "Handmade by Hannah", status: 1)
      merch_3 = Merchant.create!(name: "Curiosities", status: 1)

      expect(Merchant.enabled_merchants).to contain_exactly(merch_2, merch_3)
    end

    it ".disabled_merchants" do
      merch_1 = Merchant.create!(name: "Shop Here")
      merch_2 = Merchant.create!(name: "Handmade by Hannah", status: 1)
      merch_3 = Merchant.create!(name: "Curiosities", status: 1)
      expect(Merchant.disabled_merchants).to contain_exactly(merch_1)
    end

    it ".top_5_merchants_by_revenue" do
      merch_1 = Merchant.create!(name: "Shop Here")
      merch_2 = Merchant.create!(name: "Handmade by Hannah")
      merch_3 = Merchant.create!(name: "Curiosities")
      merch_4 = Merchant.create!(name: "Virtual Dollar Store")
      merch_5 = Merchant.create!(name: "Old Fashioned Candy")
      merch_6 = Merchant.create!(name: "Dahlia Bulbs")

      item_1 = Item.create!(name:"jumprope", description:"Pink and sparkly.", unit_price:600, merchant_id:"#{merch_1.id}")
      item_2 = Item.create!(name:"Serving Bowl", description: "Big enough for soup.", unit_price:600, merchant_id:"#{merch_2.id}")
      item_3 = Item.create!(name:"Hoosier Cabinet", description:"Old-fashioned baking cabinet.", unit_price:600, merchant_id:"#{merch_3.id}")
      item_4 = Item.create!(name:"Personal Fan and Mister", description:"Keep cool in summer, even outdoors!", unit_price:600, merchant_id:"#{merch_4.id}")
      item_5 = Item.create!(name:"Lemon Drops", description:"Sweet and sour.", unit_price:600, merchant_id:"#{merch_5.id}")

      cust_1 = Customer.create!(first_name:"Kimmy", last_name:"Gibbler")
      cust_2 = Customer.create!(first_name:"Bob", last_name:"Sagget")
      cust_3 = Customer.create!(first_name:"Uncle", last_name:"Dave")
      cust_4 = Customer.create!(first_name:"Uncle", last_name:"Jessie")
      cust_5 = Customer.create!(first_name:"DJ", last_name:"Tanner")

      invoice_1 = Invoice.create!(customer_id:"#{cust_1.id}", status:1)
      invoice_2 = Invoice.create!(customer_id:"#{cust_2.id}", status:1)
      invoice_3 = Invoice.create!(customer_id:"#{cust_3.id}", status:1)
      invoice_4 = Invoice.create!(customer_id:"#{cust_4.id}", status:1)
      invoice_5 = Invoice.create!(customer_id:"#{cust_5.id}", status:1)

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

      expect(Merchant.top_5_merchants_by_revenue).to contain_exactly(merch_5, merch_4, merch_3, merch_2, merch_1)
    end

  end

end
