class MerchantBulkDiscountsController < ApplicationController 

  def index 
    @bulk_discounts = BulkDiscount.where(merchant_id: params[:merchant_id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.new 
  end

  def show 
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def create 
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = merchant.bulk_discounts.create!(bulk_discount_params)
    redirect_to merchant_bulk_discounts_path(merchant)
  end

  private 
  def bulk_discount_params
    params.require(:bulk_discount).permit(:percentage, :quantity)
  end
end
