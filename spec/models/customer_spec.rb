require 'rails_helper'

RSpec.describe Customer, type: :model do

  describe "relationships" do
    it {should have_many(:invoices) }
    it {should have_many(:transactions).through(:invoices) }
    it {should have_many(:invoice_items).through(:invoices) }
    it {should have_many(:items).through(:invoice_items) }
    it {should have_many(:merchants).through(:items) }
  end

  describe "methods" do

    it ".favorite_customers" do
      @merch_1 = Merchant.create!(name: "Shop Here")

      @item_1 = Item.create!(name:"jumprope", description:"Pink and sparkly.", unit_price:600, merchant_id:"#{@merch_1.id}")

      @cust_1 = Customer.create!(first_name:"Hannah", last_name:"Warner")
      @cust_2 = Customer.create!(first_name:"Kimmy", last_name:"Gibbler")
      @cust_3 = Customer.create!(first_name:"Bob", last_name:"Sagget")
      @cust_4 = Customer.create!(first_name:"Uncle", last_name:"Dave")
      @cust_5 = Customer.create!(first_name:"Uncle", last_name:"Jessie")
      @cust_6 = Customer.create!(first_name:"DJ", last_name:"Tanner")

      @invoice_1 = Invoice.create!(customer_id:"#{@cust_2.id}", status:1)
      @invoice_2 = Invoice.create!(customer_id:"#{@cust_3.id}", status:1)
      @invoice_3 = Invoice.create!(customer_id:"#{@cust_4.id}", status:1)
      @invoice_4 = Invoice.create!(customer_id:"#{@cust_5.id}", status:1)
      @invoice_5 = Invoice.create!(customer_id:"#{@cust_6.id}", status:1)

      @transaction_1 = Transaction.create(invoice_id:"#{@invoice_1.id}", result: "success")
      @transaction_2 = Transaction.create(invoice_id:"#{@invoice_2.id}", result: "success")
      @transaction_3 = Transaction.create(invoice_id:"#{@invoice_3.id}", result: "success")
      @transaction_4 = Transaction.create(invoice_id:"#{@invoice_4.id}", result: "success")
      @transaction_5 = Transaction.create(invoice_id:"#{@invoice_5.id}", result: "success")

      @invoice_item_1 = InvoiceItem.create!(invoice_id:"#{@invoice_1.id}", item_id:"#{@item_1.id}", status: 1, quantity:1, unit_price:600)
      @invoice_item_2 = InvoiceItem.create!(invoice_id:"#{@invoice_2.id}", item_id:"#{@item_1.id}", status: 1, quantity:1, unit_price:600)
      @invoice_item_3 = InvoiceItem.create!(invoice_id:"#{@invoice_3.id}", item_id:"#{@item_1.id}", status: 2, quantity:1, unit_price:600)
      @invoice_item_4 = InvoiceItem.create!(invoice_id:"#{@invoice_4.id}", item_id:"#{@item_1.id}", status: 2, quantity:1, unit_price:600)
      @invoice_item_5 = InvoiceItem.create!(invoice_id:"#{@invoice_5.id}", item_id:"#{@item_1.id}", status: 2, quantity:1, unit_price:600)
      expect(Customer.favorite_customers).to contain_exactly(@cust_2, @cust_3, @cust_4, @cust_5, @cust_6)
    end

  end


  describe '::top_five_customers' do
    it 'shows the top 5 custromers based on number of successful transactions' do
      merchant_1 = Merchant.create!(name: "Shop Here")

      customer1 = Customer.create!(first_name:"first name 1", last_name:"last name 1")
      customer2 = Customer.create!(first_name:"first name 2", last_name:"last name 2")
      customer3 = Customer.create!(first_name:"first name 3", last_name:"last name 3")
      customer4 = Customer.create!(first_name:"first name 4", last_name:"last name 4")
      customer5 = Customer.create!(first_name:"first name 5", last_name:"last name 5")
      customer6 = Customer.create!(first_name:"first name 6", last_name:"last name 6")
      customer7 = Customer.create!(first_name:"first name 7", last_name:"last name 7")
      customer8 = Customer.create!(first_name:"first name 8", last_name:"last name 8")
      customer9 = Customer.create!(first_name:"first name 9", last_name:"last name 9")
      customer10 = Customer.create!(first_name:"first name 10", last_name:"last name 10")

      invoice_1 = Invoice.create!(customer_id: customer1.id, status:0)
      invoice_2 = Invoice.create!(customer_id: customer1.id, status:1)
      invoice_3 = Invoice.create!(customer_id: customer1.id, status:0)

      invoice_4 = Invoice.create!(customer_id: customer2.id, status:0)
      invoice_5 = Invoice.create!(customer_id: customer2.id, status:1)
      invoice_6 = Invoice.create!(customer_id: customer2.id, status:0)

      invoice_7 = Invoice.create!(customer_id: customer3.id, status:0)
      invoice_8 = Invoice.create!(customer_id: customer3.id, status:1)
      invoice_9 = Invoice.create!(customer_id: customer3.id, status:0)

      invoice_10 = Invoice.create!(customer_id: customer4.id, status:0)
      invoice_11 = Invoice.create!(customer_id: customer4.id, status:1)

      invoice_12 = Invoice.create!(customer_id: customer5.id, status:0)
      invoice_13 = Invoice.create!(customer_id: customer5.id, status:0)

      invoice_14 = Invoice.create!(customer_id: customer6.id, status:1)
      invoice_15 = Invoice.create!(customer_id: customer7.id, status:0)
      invoice_16 = Invoice.create!(customer_id: customer8.id, status:0)
      invoice_17 = Invoice.create!(customer_id: customer9.id, status:1)
      invoice_18 = Invoice.create!(customer_id: customer10.id, status:0)

      item_1 = Item.create!(name:"jumprope", description:"Pink and sparkly.", unit_price:600, merchant_id: merchant_1.id)

      InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, status: 1, quantity:1, unit_price:600)
      InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_1.id, status: 1, quantity:1, unit_price:600)
      InvoiceItem.create!(invoice_id: invoice_3.id, item_id: item_1.id, status: 1, quantity:1, unit_price:600)
      InvoiceItem.create!(invoice_id: invoice_4.id, item_id: item_1.id, status: 1, quantity:1, unit_price:600)
      InvoiceItem.create!(invoice_id: invoice_5.id, item_id: item_1.id, status: 1, quantity:1, unit_price:600)
      InvoiceItem.create!(invoice_id: invoice_6.id, item_id: item_1.id, status: 1, quantity:1, unit_price:600)
      InvoiceItem.create!(invoice_id: invoice_7.id, item_id: item_1.id, status: 1, quantity:1, unit_price:600)
      InvoiceItem.create!(invoice_id: invoice_8.id, item_id: item_1.id, status: 1, quantity:1, unit_price:600)
      InvoiceItem.create!(invoice_id: invoice_9.id, item_id: item_1.id, status: 1, quantity:1, unit_price:600)
      InvoiceItem.create!(invoice_id: invoice_10.id, item_id: item_1.id, status: 1, quantity:1, unit_price:600)
      InvoiceItem.create!(invoice_id: invoice_11.id, item_id: item_1.id, status: 1, quantity:1, unit_price:600)
      InvoiceItem.create!(invoice_id: invoice_12.id, item_id: item_1.id, status: 1, quantity:1, unit_price:600)
      InvoiceItem.create!(invoice_id: invoice_13.id, item_id: item_1.id, status: 1, quantity:1, unit_price:600)
      InvoiceItem.create!(invoice_id: invoice_14.id, item_id: item_1.id, status: 1, quantity:1, unit_price:600)
      InvoiceItem.create!(invoice_id: invoice_15.id, item_id: item_1.id, status: 1, quantity:1, unit_price:600)
      InvoiceItem.create!(invoice_id: invoice_16.id, item_id: item_1.id, status: 1, quantity:1, unit_price:600)
      InvoiceItem.create!(invoice_id: invoice_17.id, item_id: item_1.id, status: 1, quantity:1, unit_price:600)
      InvoiceItem.create!(invoice_id: invoice_18.id, item_id: item_1.id, status: 1, quantity:1, unit_price:600)


      transaction_1 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_1.id)
      transaction_19 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "failed", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_1.id)
      transaction_2 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_2.id)
      transaction_3 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_3.id)
      transaction_4 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_4.id)
      transaction_5 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_5.id)
      transaction_6 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_6.id)
      transaction_7 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_7.id)
      transaction_8 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_8.id)
      transaction_9 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_9.id)
      transaction_10 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_10.id)
      transaction_20 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "failed", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_10.id)
      transaction_11 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_11.id)
      transaction_12 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_12.id)
      transaction_13 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_13.id)
      transaction_14 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_14.id)
      transaction_15 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_15.id)
      transaction_16 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_16.id)
      transaction_17 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_17.id)
      transaction_18 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_18.id)


      expect(Customer.top_five_customers).to eq([customer1, customer2, customer3, customer4, customer5])
    end
  end


end
