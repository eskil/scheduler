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

  test "where recurring on days by string" do
    schedules = Schedule.where_recurring_on_days("mon tue wed").to_a
    assert_equal 2, schedules.count
    assert schedules.include? schedules(:sail_mondays)
    assert schedules.include? schedules(:scuba_tuesdays)
  end
end
