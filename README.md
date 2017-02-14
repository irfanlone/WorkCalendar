# WorkCalendar

Welcome to Work Calendar. To experiment with that code, run `bin/console` for an interactive prompt.

# table
- [implementation](#implementation)
- [consideration and trade-offs](#consideration-and-trade-offs)
- [some special cases](#some-special-cases)
- [usage](#usage)

## Implementation

All the main logic in the gem is being maintained in `work_calendar.rb` file. I chose to implement the functionality using a module to provide the flexibility to consume this library as mixin by other components. all the methods are implemented as class level as methods. mainly becuause we do not need class instantiation to perform these operations.

Tests are written using `rspec`

## Consideration and trade-offs
1. whether to implement using module or a class: I went ahead with implmenting this as a module provides providing methods that you can use across multiple classes. thinking about them as library (one of the main points in requirement)
2. class methods or instance methods:
I went ahead with class level methods mainly becuause we do not need class instantiation to perform these operations. These operations can be performed independent of the behaviour of the class that is consuming it. To verify it works as intended I have added a `TestCal` class which can be used to test the library (module) is behaving as intended when consumed by other classes. To do so jut execute the bellow line
```
 # this just calls the test method in TestCal class which calls configure method in module
 TestCal.new.test
```
### some special cases
I encountered few special cases (edge cases) some of them are:

1. when the block passed to configure does not contain a list
    - configure method handles this case by setting the missing list to empty array (if both are not passed, both are set to empty array).
    - `active?` method handles this by checking only the non empty list to see if the given date is active or not.

2. negative number being passed to days_after/before method
    - this is being handled by returning the given the date back when a number is negative.

3. given date is newer than the end date for the between method
    - this is handled by returning empty array in this case
    

## Usage
Some of the operations you can perform

### Clone the repo
`https://github.com/sujaysudheenda/WorkCalendar.git`
`cd WorkCalendar`

### Run the console
`bin/console`

### Configure a calendar
```
WorkCalendar.configure do |c|
  c.weekdays = %i[mon tue wed thu fri]
  c.holidays = [Date.new(2015, 1, 1), Date.new(2015, 7, 3), Date.new(2015, 12, 25)]
end
```

### determine if a given date is "active"
`WorkCalendar.active?(Date.new(2014, 1, 5))`

### return the date the specified number of "active" days *before* a date
`WorkCalendar.days_before(5, Date.new(2015, 1, 5))`

### return the date the specified number of "active" days *after* a date
`WorkCalendar.days_after(5, Date.new(2015, 1, 5))`

### return the "active" dates between two dates, exclusive of the second date
`WorkCalendar.between(Date.new(2015, 1, 1), Date.new(2015, 1, 8))`

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

