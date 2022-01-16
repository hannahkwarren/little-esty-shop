class MerchantBulkDiscountsController < ApplicationController 
  before_action :get_merchant
  before_action :set_bulk_discount, only: [:show, :edit, :update, :destroy]

  def index 
    @bulk_discounts = BulkDiscount.where(merchant_id: params[:merchant_id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.new 
  end

  def create 
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = merchant.bulk_discounts.create(bulk_discount_params)
    redirect_to merchant_bulk_discounts_path(merchant)
  end

  def show 
  end

  def edit 
  end

  def update
    if @bulk_discount.update(bulk_discount_params)
      redirect_to merchant_bulk_discount_path(@merchant, @bulk_discount)
    else
      redirect_to edit_merchant_bulk_discount_path(@merchant, @bulk_discount)
    end
  end

  def destroy 
    @bulk_discount.destroy
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  private 
  def bulk_discount_params
    params.require(:bulk_discount).permit(:percentage, :quantity)
  end

  def get_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def set_bulk_discount
    @bulk_discount = BulkDiscount.find(params[:id])
  end
end
