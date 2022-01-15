class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show

  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    discount = merchant.bulk_discounts.create!(bulk_discount_params)

    redirect_to "/merchants/#{merchant.id}/bulk_discounts"
  end

  private

  def bulk_discount_params
    params.permit(:name, :percentage, :threshold)
  end
end
