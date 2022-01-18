class ApplicationController < ActionController::Base
  before_action :get_holidays 

  def get_holidays 
    @holidays = HolidayService.new
  end
end
