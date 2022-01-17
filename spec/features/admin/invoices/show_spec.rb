require 'rails_helper'

RSpec.describe 'Admin Invoice Show Page' do
  before(:each) do
    @merch_1 = Merchant.create!(name: "Shop Here")

    @item_1 = Item.create!(name:"jumprope", description:"Pink and sparkly.", unit_price:600, merchant_id:"#{@merch_1.id}")
    @item_2 = Item.create!(name:"hula hoop", description:"Get your groove on!", unit_price:700, merchant_id:"#{@merch_1.id}")

    @cust_1 = Customer.create!(first_name:"Hannah", last_name:"Warner")

    @invoice_1 = Invoice.create!(customer_id:"#{@cust_1.id}", status:1)
    @invoice_2 = Invoice.create!(customer_id:"#{@cust_1.id}", status:1)
    @invoice_3 = Invoice.create!(customer_id:"#{@cust_1.id}", status:1)

    @invoice_item_1 = InvoiceItem.create!(invoice_id:"#{@invoice_1.id}", item_id:"#{@item_1.id}", status: 2, quantity:1, unit_price:600)
    @invoice_item_2 = InvoiceItem.create!(invoice_id:"#{@invoice_2.id}", item_id:"#{@item_2.id}", status: 2, quantity:10, unit_price:700)
    @invoice_item_3 = InvoiceItem.create!(invoice_id:"#{@invoice_3.id}", item_id:"#{@item_2.id}", status: 2, quantity:1, unit_price:700)

    @bulk_discount_1 = BulkDiscount.create(merchant_id: @merch_2, percentage: 10, quantity:10)
  end

  it 'shows customer and status information for the invoice' do
    visit admin_invoice_path(@invoice_1)

    expect(page).to have_content("Invoice ID: #{@invoice_1.id}")
    expect(page).to have_content("Invoice Status: #{@invoice_1.status}")
    expect(page).to have_content(@invoice_1.created_at.strftime("%A, %B %d, %Y"))
    expect(page).to have_content(@cust_1.first_name)
    expect(page).to have_content(@cust_1.last_name)
  end

  it 'shows Item information for the the show page' do
    visit admin_invoice_path(@invoice_1)

    within ".invoice" do
      expect(page).to have_content(@item_1.name)
      expect(page).to_not have_content(@item_2.name)
      expect(page).to have_content(@invoice_item_1.quantity)
      expect(page).to have_content(@invoice_item_1.unit_price)
      expect(page).to_not have_content(@invoice_item_3.unit_price)
      expect(page).to have_content(@invoice_item_1.status)
    end
  end

  it 'shows total revenue for generated from an invoice' do
    visit admin_invoice_path(@invoice_1)

    within ".total_revenue" do
    expect(page).to have_content("Total Revenue: #{@invoice_1.total_revenue}")
    end
  end

  it 'uses a select field to update invoice status' do
    visit admin_invoice_path(@invoice_1)

    expect(page).to have_content(@invoice_1.status)
    select 'completed', from: "Status"

    click_button "Update Status"

    expect(current_path).to eq(admin_invoices_path(:id))
    expect(@invoice_1.status).to eq('completed')
  end

  it 'has total discounted revenue' do 

    visit admin_invoice_path(@invoice_2.id)

    expect(page).to have_content("Total Revenue: #{@invoice_2.total_revenue}")
    expect(page).to have_content("Total Discounted Revenue: #{@invoice_2.total_discounted_revenue}")
  end

end
