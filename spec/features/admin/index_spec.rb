require 'rails_helper'

RSpec.describe 'Admin Dashboard Index page' do
  it 'shows admin header' do
    visit admin_index_path

    expect(page).to have_content("Welcome to Admin Dashboard")
  end

  it 'shows links to admin merchants index' do
    visit admin_index_path

    expect(page).to have_link("Admin Merchants Index")
    click_link "Admin Merchants Index"
    expect(current_path).to eq(admin_merchants_path)
  end

  it 'shows links to admin invoices index' do
    visit admin_index_path

    expect(page).to have_link("Invoices")
    click_link "Invoices"
    expect(current_path).to eq(admin_invoices_path)
  end

  describe "Incomplete Invoices" do
    it "lists all Incomplete Invoices Ids" do
      cust_1 = Customer.create!(first_name:"Hannah", last_name:"Warner")

      invoice_1 = Invoice.create!(customer_id:"#{cust_1.id}", status:0)
      invoice_2 = Invoice.create!(customer_id:"#{cust_1.id}", status:1)
      invoice_3 = Invoice.create!(customer_id:"#{cust_1.id}", status:0)

      visit admin_index_path

      expect(page).to_not have_content(invoice_2.id)

      expect(page).to have_content(invoice_1.id)
      expect(page).to have_content(invoice_3.id)
    end

    it "shows Incomplete Invoice Ids as links to that invoices admin show page" do
      cust_1 = Customer.create!(first_name:"Hannah", last_name:"Warner")

      invoice_1 = Invoice.create!(customer_id:"#{cust_1.id}", status:0)
      invoice_2 = Invoice.create!(customer_id:"#{cust_1.id}", status:1)
      invoice_3 = Invoice.create!(customer_id:"#{cust_1.id}", status:0)

      visit admin_index_path

      click_link "#{invoice_1.id}"

      expect(current_path).to eq("/admin/invoices/#{invoice_1.id}")
    end

    it 'sees the names of the top 5 customers who have conducted the largest number of successful transactions' do
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

      invoice_1 = Invoice.create!(customer_id:"#{customer1.id}", status:0)
      invoice_2 = Invoice.create!(customer_id:"#{customer1.id}", status:1)
      invoice_3 = Invoice.create!(customer_id:"#{customer1.id}", status:0)

      invoice_4 = Invoice.create!(customer_id:"#{customer2.id}", status:0)
      invoice_5 = Invoice.create!(customer_id:"#{customer2.id}", status:1)
      invoice_6 = Invoice.create!(customer_id:"#{customer2.id}", status:0)

      invoice_7 = Invoice.create!(customer_id:"#{customer3.id}", status:0)
      invoice_8 = Invoice.create!(customer_id:"#{customer3.id}", status:1)
      invoice_9 = Invoice.create!(customer_id:"#{customer3.id}", status:0)

      invoice_10 = Invoice.create!(customer_id:"#{customer4.id}", status:0)
      invoice_11 = Invoice.create!(customer_id:"#{customer4.id}", status:1)

      invoice_12 = Invoice.create!(customer_id:"#{customer5.id}", status:0)
      invoice_13 = Invoice.create!(customer_id:"#{customer5.id}", status:0)

      invoice_14 = Invoice.create!(customer_id:"#{customer6.id}", status:1)
      invoice_15 = Invoice.create!(customer_id:"#{customer7.id}", status:0)
      invoice_16 = Invoice.create!(customer_id:"#{customer8.id}", status:0)
      invoice_17 = Invoice.create!(customer_id:"#{customer9.id}", status:1)
      invoice_18 = Invoice.create!(customer_id:"#{customer10.id}", status:0)

      transaction_1 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_1.id)
      transaction_2 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_2.id)
      transaction_3 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_3.id)
      transaction_4 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_4.id)
      transaction_5 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_5.id)
      transaction_6 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_6.id)
      transaction_7 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_7.id)
      transaction_8 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_8.id)
      transaction_9 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_9.id)
      transaction_10 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_10.id)
      transaction_11 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_11.id)
      transaction_12 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_12.id)
      transaction_13 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_13.id)
      transaction_14 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_14.id)
      transaction_15 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_15.id)
      transaction_16 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_16.id)
      transaction_17 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_17.id)
      transaction_18 = Transaction.create!(credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09", invoice_id: invoice_18.id)

      visit admin_index_path

      expect(page).to have_content("Top Customers")
      expect(page).to have_content(customer1.first_name)
      expect(page).to have_content(customer2.first_name)
      expect(page).to have_content(customer3.first_name)
      expect(page).to have_content(customer4.first_name)
      expect(page).to have_content(customer5.first_name)
    end
  end
end
