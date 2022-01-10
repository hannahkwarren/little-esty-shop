class MerchantInvoicesController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @invoices = Invoice.merchants_invoices(@merchant)
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @invoice = Invoice.find(params[:id])
    @invoice_items = @invoice.invoice_items
  end
end
