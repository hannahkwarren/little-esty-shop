# merch_1 = Merchant.create!(name: "Handmade by Hannah")

# item_1 = Item.create!(name:"Sleepy Robot Mug", description:"For coffee. Lots of coffee.", unit_price:6000, merchant_id: merch_1.id)
# item_2 = Item.create!(name:"Serving Bowl", description:"More attractive to put on the dinner table.", unit_price:10000, merchant_id:merch_1.id)

# merch_2 = Merchant.create!(name: "Target")

# item_3 = Item.create!(name:"Boring White Mug", description: "Minimal, textureless white glaze.", unit_price:250, merchant_id: merch_2.id)
# item_4 = Item.create!(name:"Boring White Serving Bowl", description: "Only slightly more attractive for the dinner table.", unit_price:500, merchant_id: merch_2.id)

# cust_1 = Customer.create!(first_name:"Kimmy", last_name:"Gibbler")
# cust_2 = Customer.create!(first_name:"Bob", last_name:"Sagget")
# cust_3 = Customer.create!(first_name:"Uncle", last_name:"Dave")

# invoice_1 = Invoice.create!(customer_id:cust_1.id, status:1)
# invoice_2 = Invoice.create!(customer_id:cust_2.id, status:1)
# invoice_3 = Invoice.create!(customer_id:cust_3.id, status:1)

# invoice_item_1 = InvoiceItem.create!(invoice_id:invoice_1.id, item_id:item_1.id, status: 2, quantity:1, unit_price:6000, created_at: "2022-01-06 01:45:03", updated_at: "2022-01-06 01:45:03")
# invoice_item_2 = InvoiceItem.create!(invoice_id:invoice_1.id, item_id:item_2.id, status: 2, quantity:10, unit_price:10000, created_at: "2022-01-06 01:45:03", updated_at: "2022-01-06 01:45:03")

# invoice_item_3 = InvoiceItem.create!(invoice_id:invoice_2.id, item_id:item_1.id, status: 2, quantity:20, unit_price:6000)
# invoice_item_4 = InvoiceItem.create!(invoice_id:invoice_2.id, item_id:item_1.id, status: 2, quantity:1, unit_price:10000)

# invoice_item_5 = InvoiceItem.create!(invoice_id:invoice_3.id, item_id:item_1.id, status: 2, quantity:10, unit_price:6000)
# invoice_item_5 = InvoiceItem.create!(invoice_id:invoice_3.id, item_id:item_2.id, status: 2, quantity:20, unit_price:10000)

# transaction_1 = Transaction.create!(invoice_id:invoice_1.id, result: "success")
# transaction_2 = Transaction.create!(invoice_id:invoice_2.id, result: "success")
# transaction_3 = Transaction.create!(invoice_id:invoice_3.id, result: "success")

# bulk_discount_1 = BulkDiscount.create!(merchant_id: merch_1.id, percentage: 15, quantity:20)
# bulk_discount_2 = BulkDiscount.create!(merchant_id: merch_1.id, percentage: 10, quantity:10)
# bulk_discount_3 = BulkDiscount.create!(merchant_id: merch_2.id, percentage: 20, quantity: 6)
