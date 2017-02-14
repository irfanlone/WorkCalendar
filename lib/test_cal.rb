require 'work_calendar'

# simple stub to test our lib works properly when included in other classes
class TestCal
  include WorkCalendar

  # public: test configuring a WorkCalendar
  #
  # Returns configured calendar
  def test
    WorkCalendar.configure do |c|
      c.weekdays = %i(mon tue wed thu fri)
      c.holidays = [Date.new(2015, 1, 1), Date.new(2015, 7, 3), Date.new(2015, 12, 25)]
    end
  end
end
