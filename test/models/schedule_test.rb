require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  test "is recurring" do
    assert_equal true, schedules(:sail_mondays).is_recurring?
    assert_equal false, schedules(:sail_xmas).is_recurring?
  end
end
