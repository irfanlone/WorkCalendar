require 'work_calendar/version'

module WorkCalendar
  # maintain a hash to map the Date.wday which returns a number between 0-7
  DAY = {
    0 => :sun,
    1 => :mon,
    2 => :tue,
    3 => :wed,
    4 => :thu,
    5 => :fri,
    6 => :sat
  }.freeze

  # No need to instantiate an object so make everythinng class level methods
  class << self
    attr_accessor :weekdays, :holidays

    # Public: configure the calendar based on given block
    #
    # sets both weekdays and holidays to empty if no block provided
    def configure
      yield self if block_given?

      self.weekdays ||= []
      self.holidays ||= []
    end

    # Public: check if given date is active date
    #
    # date - A Date object which needs to be verified
    #
    # Returns true if date is active else returns false
    def active?(date)
      case [weekdays.empty?, holidays.empty?]
      when [true, true]
        return true
      when [false, true]
        return weekdays.include?(DAY[date.wday])
      when [true, false]
        return !holidays.include?(date)
      else
        weekdays.include?(DAY[date.wday]) && !holidays.include?(date)
      end
    end

    # Public: find the active date which occured *number* of days before given date
    #
    # number - number which specifying how old the date should be
    # date   - Date object specifying the current date
    #
    # Returns a Date object
    def days_before(number, date)
      current_date = date

      until number <= 0
        number -= 1 if active?(current_date.prev_day)
        current_date = current_date.prev_day
      end

      current_date
    end

    # Public: find the active date which will occur *number* of days after given date
    #
    # number - number which specifying how *new* the date should be
    # date   - Date object specifying the current date
    #
    # Returns a Date object
    def days_after(number, date)
      current_date = date

      until number <= 0
        number -= 1 if active?(current_date.next_day)
        current_date = current_date.next_day
      end

      current_date
    end

    # Public: find all active dates between given interval of dates
    #
    # first_date - Date object containing start date
    # last_date  - Date object containging end date
    #
    # Returns an array of Date objects which are active
    def between(first_date, last_date)
      return [] if first_date > last_date
      current_date = first_date
      active_dates = []
      until current_date >= last_date
        active_dates << current_date if active?(current_date)
        current_date = current_date.next_day
      end

      active_dates
    end
  end
end
