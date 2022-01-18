class Holiday
  attr_reader :date, :holiday

  def initialize(data)
    @date = data[:date]
    @holiday = data[:name]
  end
end
