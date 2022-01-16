require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to :invoice }
    it { should belong_to :item }
    it { should have_many(:bulk_discounts).through(:merchants) }
  end
  describe '#discount' do
    it 'associates a invoice_item with an eligible discount' do
      merchant = Merchant.create!(name: 'merchant name')
      discount_1 = merchant.bulk_discounts.create!(title: 'A', qty_threshold: 10, percentage: 20)
      discount_2 = merchant.bulk_discounts.create!(title: 'B', qty_threshold: 15, percentage: 30)
      discount_3 = merchant.bulk_discounts.create!(title: 'c', qty_threshold: 11, percentage: 25)
      not_included_merchant = Merchant.create!(name: 'merchant name')
      customer = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
      item_1 = Item.create!(merchant_id: merchant.id, name: 'widget-1', description: 'widget description',
                            unit_price: 100)

      invoice = Invoice.create!(customer_id: customer.id, status: 'completed')

      invoice_item_1 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_1.id, quantity: 10,
                                           unit_price: 700)
      invoice_item_2 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_1.id, quantity: 15,
                                           unit_price: 300)
      invoice_item_3 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_1.id, quantity: 5,
                                           unit_price: 100)
      actual = invoice_item_1.discount
      expected = discount_1
      expect(actual).to eq(expected)
      actual = invoice_item_2.discount
      expected = discount_2
      expect(actual).to eq(expected)
      actual = invoice_item_3.discount
      expected = nil
      expect(actual).to eq(expected)
    end
  end
  describe 'discounted_rev' do
    it 'applys a single discount to a invoice_item' do
      merchant = Merchant.create!(name: 'merchant name')
      discount_1 = merchant.bulk_discounts.create!(title: 'A', qty_threshold: 10, percentage: 20)
      discount_2 = merchant.bulk_discounts.create!(title: 'B', qty_threshold: 15, percentage: 30)
      discount_3 = merchant.bulk_discounts.create!(title: 'c', qty_threshold: 11, percentage: 25)
      not_included_merchant = Merchant.create!(name: 'merchant name')
      customer = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
      item_1 = Item.create!(merchant_id: merchant.id, name: 'widget-1', description: 'widget description',
                            unit_price: 100)

      invoice = Invoice.create!(customer_id: customer.id, status: 'completed')

      invoice_item_1 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_1.id, quantity: 10,
                                           unit_price: 700)
      invoice_item_2 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_1.id, quantity: 15,
                                           unit_price: 300)
      invoice_item_3 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_1.id, quantity: 5,
                                           unit_price: 100)

      actual = invoice_item_1.discounted_rev
      expected = 5600
      expect(actual).to eq(expected)
      actual = invoice_item_2.discounted_rev
      expected = 3150.0
      expect(actual).to eq(expected)
      actual = invoice_item_3.discounted_rev
      expected = 500
      expect(actual).to eq(expected)
    end
  end
end
