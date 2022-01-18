class HolidayService
  def holidays
    get_url('nextpublicholidays/us')
  end

  def get_url(url)
    response = HTTParty.get "https://date.nager.at/api/v3/#{url}"
    JSON.parse(response.body, symbolize_names: true)
  end
end
