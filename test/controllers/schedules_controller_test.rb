require 'test_helper'

class SchedulesControllerTest < ActionController::TestCase
  test "query date" do
    activity = activities(:sail)
    schedule = schedules(:sail_xmas)

    # Query the right date gives a hit
    get :query, :format => :json, :date => schedule.date_at.strftime("%F")
    assert_response :success
    body = JSON.parse(response.body)
    puts body
    assert_equal 1, body.count
  end
end
