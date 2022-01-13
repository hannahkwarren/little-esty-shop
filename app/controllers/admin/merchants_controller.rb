class Admin::MerchantsController < ApplicationController

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
    flash.keep
  end

  def new 
    @merchant = Merchant.new
  end

  def create 
    merchant = Merchant.create(admin_merchant_params)

    if merchant.save
      redirect_to "/admin/merchants"
    else
      redirect_to "/admin/merchants/new"
    end
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])

    if params[:status].present?
      merchant.update(status: params[:status])
      redirect_to admin_merchants_path 
      flash[:success] = merchant.name + ' was successfully updated.'
    else 
      merchant.update(admin_merchant_params)
      flash[:success] = merchant.name + ' was successfully updated.'
      redirect_to admin_merchant_path(merchant)
    end
  
  end

  private
  def admin_merchant_params
    params.require(:merchant).permit(:id, :name, :status)
  end
end
