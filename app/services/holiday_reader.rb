class HolidayReader
  def holidays
    holidays = []
    service.holidays.each do |data|
      if holidays.length < 3
        holiday = Holiday.new(data)
        holidays << holiday
      end
    end

    holidays
  end

  def service
    HolidayService.new
  end
end
