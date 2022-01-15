class MerchantBulkDiscountsController < ApplicationController 

  def index 
    @bulk_discounts = BulkDiscount.where(merchant_id: params[:merchant_id])
  end

  def show 
    @bulk_discount = BulkDiscount.find(params[:id])
  end

end
