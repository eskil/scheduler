require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  test "is recurring" do
    assert_equal true, schedules(:sail_mondays).is_recurring?
    assert_equal false, schedules(:sail_xmas).is_recurring?
  end

  test "occurs on" do
    assert_equal false, (schedules(:sail_mondays).recurs_on? 0)
    assert_equal true, (schedules(:sail_mondays).recurs_on? 1)
  end
end
