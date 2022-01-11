class Admin::MerchantsController < ApplicationController

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(merchant_params[:id])
  end

  def new 
    @merchant = Merchant.new
  end

  def create 
    merchant = Merchant.new(merchant_params)

    if merchant.save
      redirect_to "/admin/merchants"
    else
      redirect_to "/admin/merchants/new"
      flash[:alert] = "Error: #{error_message(merchant.errors)}"
    end
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])
    
    if merchant_params.present?
      merchant.update(merchant_params)
      flash[:success] = merchant.name + ' was successfully updated.'

      redirect_to admin_merchant_path
    else
      flash[:alert] = "Error: #{error_message(merchant.errors)}"
    end
      
      # if(params[:redirect_to]) == "index"
      #   redirect_to admin_merchants_path
      # else
      #   redirect_to admin_merchant_path(params[:id])
      # end
      
    
    # binding.pry
  end

private 

  def merchant_params
    params.require(:merchant).permit(:name, :status)
  end

end
