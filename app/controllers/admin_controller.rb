class AdminController < ApplicationController

  def index
    @invoices = Invoice.all
    @customers = Customer.top_five_customers
  end

  def show

  end
end
