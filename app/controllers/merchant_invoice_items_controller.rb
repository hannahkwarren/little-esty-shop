class MerchantInvoiceItemsController < ApplicationController

  def update
    invoice_item = InvoiceItem.find(params[:id])
    invoice_item.update(invoice_item_params)
    require "pry"; binding.pry
    redirect_to merchant_invoice_path(invoice_item.item.merchant, invoice_item.item_id)
  end

private
  def invoice_item_params
    params.require(:invoice_item).permit(:status)
  end
end
