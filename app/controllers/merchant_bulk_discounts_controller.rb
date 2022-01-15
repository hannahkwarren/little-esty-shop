class MerchantBulkDiscountsController < ApplicationController
  def index
    @bulk_discounts = BulkDiscount.where(merchant_id: params[:merchant_id])
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.new(merchant_id: @merchant.id)
  end

  def create
    bulk_discount = BulkDiscount.create(bulk_discount_params)
    bulk_discount.merchant_id = params[:merchant_id]
    bulk_discount.save
    redirect_to merchant_bulk_discounts_path(bulk_discount.merchant)
  end

  def destroy
    bulk_discount = BulkDiscount.find(params[:id])
    bulk_discount.destroy
    redirect_to merchant_bulk_discounts_path(params[:merchant_id])
  end

  private

  def bulk_discount_params
    params.require(:bulk_discount).permit(:merchant_id, :title, :qty_threshold, :percentage)
  end
end
