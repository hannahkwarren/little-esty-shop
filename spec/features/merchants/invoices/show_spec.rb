require 'rails_helper'

RSpec.describe 'merchant invoices show page' do
  it 'visits merchant inoice shopw page and displays information of that invoice' do
    merchant = Merchant.create!(name: 'merchant name')
    customer = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
    invoice = Invoice.create!(customer_id: customer.id, status: 'completed')

    visit merchant_invoice_path(merchant, invoice)

    within '.header' do
      expect(page).to have_content(invoice.id)
      expect(page).to have_content(invoice.status)
      expect(page).to have_content(invoice.created_at.strftime('%A %B %d %Y'))
      expect(page).to have_content(customer.first_name)
      expect(page).to have_content(customer.last_name)
    end
  end
  it 'lists items for an invoice and their attributes' do
    merchant = Merchant.create!(name: 'merchant name')
    not_included_merchant = Merchant.create!(name: 'merchant name')
    customer = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
    item_1 = Item.create!(merchant_id: merchant.id, name: 'widget-1', description: 'widget description',
                          unit_price: 100)
    item_2 = Item.create!(merchant_id: merchant.id, name: 'widget-2', description: 'widget description',
                          unit_price: 200)
    item_3 = Item.create!(merchant_id: merchant.id, name: 'widget-3', description: 'widget description',
                          unit_price: 300)
    item_4 = Item.create!(merchant_id: merchant.id, name: 'widget-4', description: 'widget description',
                          unit_price: 400)
    item_5 = Item.create!(merchant_id: not_included_merchant.id, name: 'widget-20', description: 'widget description',
                          unit_price: 40_440)

    invoice = Invoice.create!(customer_id: customer.id, status: 'completed')
    invoice_2 = Invoice.create!(customer_id: customer.id, status: 'completed')
    invoice_item_1 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_1.id, quantity: 7,
                                         unit_price: 100)
    invoice_item_2 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_2.id, quantity: 3,
                                         unit_price: 200)
    invoice_item_3 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_3.id, quantity: 2,
                                         unit_price: 300)
    invoice_item_4 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_4.id, quantity: 2,
                                         unit_price: 400)

    invoice_item_5 = InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_5.id, quantity: 1,
                                         unit_price: 700)

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
    item_1 = Item.create!(merchant_id: merchant.id, name: 'widget-1', description: 'widget description',
                          unit_price: 13_635)
    item_2 = Item.create!(merchant_id: merchant.id, name: 'widget-2', description: 'widget description',
                          unit_price: 23_324)
    item_3 = Item.create!(merchant_id: merchant.id, name: 'widget-3', description: 'widget description',
                          unit_price: 34_873)
    item_4 = Item.create!(merchant_id: merchant.id, name: 'widget-4', description: 'widget description',
                          unit_price: 2196)
    item_5 = Item.create!(merchant_id: not_included_merchant.id, name: 'widget-20', description: 'widget description',
                          unit_price: 79_140)
    invoice_item_1 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_1.id, quantity: 7,
                                         unit_price: 13_635)
    invoice_item_2 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_2.id, quantity: 3,
                                         unit_price: 23_324)
    invoice_item_3 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_3.id, quantity: 2,
                                         unit_price: 34_873)
    invoice_item_4 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_4.id, quantity: 2,
                                         unit_price: 2196)

    invoice_item_5 = InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_5.id, quantity: 1,
                                         unit_price: 79_140)

    visit merchant_invoice_path(merchant, invoice)

    within '.total-revenue' do
      expect(page).to have_content("Total Revenue: #{(invoice.total_revenue / 100.to_f).to_s.prepend('$').insert(2,
                                                                                                                 ',')}")
    end
  end
  it 'allows merchant to update an invoice_item status' do
    merchant = Merchant.create!(name: 'merchant name')
    customer = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
    invoice = Invoice.create!(customer_id: customer.id, status: 'completed')
    item_1 = Item.create!(merchant_id: merchant.id, name: 'widget-1', description: 'widget description',
                          unit_price: 13_635)
    invoice_item_1 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_1.id, quantity: 7,
                                         unit_price: 13_635)

    visit merchant_invoice_path(merchant, invoice)
    within ".invoice-item-#{invoice_item_1.id}" do
      select('shipped', from: 'invoice_item_status')
      click_button 'Update Invoice item'

      invoice_item_1.reload

      expect(invoice_item_1.status).to eq('shipped')
    end
  end
  it 'shows the discounted total revenue for an invoice' do
    merchant = Merchant.create!(name: 'merchant name')
    discount_1 = merchant.bulk_discounts.create!(qty_threshold: 4, percentage: 10, title: 'a')
    not_included_merchant = Merchant.create!(name: 'merchant name')
    customer = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
    invoice = Invoice.create!(customer_id: customer.id, status: 'completed')
    invoice_2 = Invoice.create!(customer_id: customer.id, status: 'completed')
    item_1 = Item.create!(merchant_id: merchant.id, name: 'widget-1', description: 'widget description',
                          unit_price: 13_635)
    item_2 = Item.create!(merchant_id: merchant.id, name: 'widget-2', description: 'widget description',
                          unit_price: 23_324)
    item_3 = Item.create!(merchant_id: merchant.id, name: 'widget-3', description: 'widget description',
                          unit_price: 34_873)
    item_4 = Item.create!(merchant_id: merchant.id, name: 'widget-4', description: 'widget description',
                          unit_price: 2196)
    item_5 = Item.create!(merchant_id: not_included_merchant.id, name: 'widget-20', description: 'widget description',
                          unit_price: 79_140)
    invoice_item_1 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_1.id, quantity: 7,
                                         unit_price: 13_635)
    invoice_item_2 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_2.id, quantity: 3,
                                         unit_price: 23_324)
    invoice_item_3 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_3.id, quantity: 2,
                                         unit_price: 34_873)
    invoice_item_4 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_4.id, quantity: 2,
                                         unit_price: 2196)

    invoice_item_5 = InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_5.id, quantity: 1,
                                         unit_price: 79_140)
    visit merchant_invoice_path(merchant, invoice)

    within '.discounted-rev' do
      expect(page).to have_content("Discounted Total Revenue: #{(invoice.discounted_total_rev / 100).to_s.prepend('$').insert(2,
                                                                                                                              ',')}")
    end
  end
  it 'has links to each invoice_items bulk_discount if any' do
    merchant = Merchant.create!(name: 'merchant name')
    discount_1 = merchant.bulk_discounts.create!(qty_threshold: 4, percentage: 10, title: 'a')
    not_included_merchant = Merchant.create!(name: 'merchant name')
    customer = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
    invoice = Invoice.create!(customer_id: customer.id, status: 'completed')
    invoice_2 = Invoice.create!(customer_id: customer.id, status: 'completed')
    item_1 = Item.create!(merchant_id: merchant.id, name: 'widget-1', description: 'widget description',
                          unit_price: 13_635)
    item_2 = Item.create!(merchant_id: merchant.id, name: 'widget-2', description: 'widget description',
                          unit_price: 23_324)
    item_3 = Item.create!(merchant_id: merchant.id, name: 'widget-3', description: 'widget description',
                          unit_price: 34_873)
    item_4 = Item.create!(merchant_id: merchant.id, name: 'widget-4', description: 'widget description',
                          unit_price: 2196)
    item_5 = Item.create!(merchant_id: not_included_merchant.id, name: 'widget-20', description: 'widget description',
                          unit_price: 79_140)
    invoice_item_1 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_1.id, quantity: 7,
                                         unit_price: 13_635)
    invoice_item_2 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_2.id, quantity: 3,
                                         unit_price: 23_324)
    invoice_item_3 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_3.id, quantity: 2,
                                         unit_price: 34_873)
    invoice_item_4 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_4.id, quantity: 2,
                                         unit_price: 2196)

    invoice_item_5 = InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_5.id, quantity: 1,
                                         unit_price: 79_140)
    visit merchant_invoice_path(merchant, invoice)

    within ".invoice-item-#{invoice_item_1.id}" do
      expect(page).to have_link(discount_1.title.to_s)
    end
    within ".invoice-item-#{invoice_item_2.id}" do
      expect(page).to_not have_link(discount_1.title.to_s)
    end
  end
end
