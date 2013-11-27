require 'test_helper'
require 'calendar_util'

class CalendarUtilTest < ActiveSupport::TestCase
  test "weekday ranges" do
    CalendarUtil::weekday_range('2013-08-19', '2013-08-18') == []
    CalendarUtil::weekday_range('2013-08-19', '2013-08-19') == [1]
    CalendarUtil::weekday_range('2013-08-19', '2013-08-24') == [1, 2, 3, 4, 5, 6]
    CalendarUtil::weekday_range('2013-08-19', '2013-08-25') == [0, 1, 2, 3, 4, 5, 6]
    CalendarUtil::weekday_range('2013-08-19', '2013-09-01') == [0, 1, 2, 3, 4, 5, 6]
    CalendarUtil::weekday_range('2013-08-17', '2013-08-21') == [0, 1, 2, 3, 6]
  end
end
