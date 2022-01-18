class HolidayService  

  def usa_upcoming_holidays 
    api = get_data
  end

  def get_data
    response = HTTParty.get "https://date.nager.at/api/v3/NextPublicHolidays/US"
    parsed = JSON.parse(response.body, symbolize_names: true)[0..2]   
  end
end
