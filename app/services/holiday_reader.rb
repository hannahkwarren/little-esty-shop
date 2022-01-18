class HolidayReader
  def holidays
    array = []
    service.holidays.each do |data|
      holiday = Holiday.new(data)
      array << holiday
    end
    require 'pry'
    binding.pry
    holidays = array[0..2]
  end

  def service
    HolidayService.new
  end
end
