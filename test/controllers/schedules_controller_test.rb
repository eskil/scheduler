require 'test_helper'

class SchedulesControllerTest < ActionController::TestCase
  test "query date" do
    activity = activities(:sail)
    schedule = schedules(:sail_new_years)
    date = schedule.date_at.strftime("%F")

    # Query the right date gives a hit
    get :query, :format => :json, :date => date
    assert_response :success
    body = JSON.parse(response.body)

    assert_equal 2, body["activities"].count
    assert_equal 1, body["availabilities"].keys.count
    assert_equal 2, body["availabilities"][date].count
    assert_equal activity.id, body["availabilities"][date][0]["activity_id"]
    assert_equal 2, body["availabilities"][date][0]["spots"]
  end

  test "query date range" do
    sail = activities(:sail)
    scuba = activities(:scuba)

    # Query the right date gives a hit
    get :query, :format => :json, :from_date => "2013-12-22", :to_date => "2014-01-01"
    assert_response :success
    body = JSON.parse(response.body)

    assert_equal 2, body["activities"].count

    assert_equal 4, body["availabilities"].keys.count

    assert_equal 1, body["availabilities"]["2013-12-23"].count
    assert_equal 6, body["availabilities"]["2013-12-23"][0]["spots"]

    assert_equal 2, body["availabilities"]["2013-12-24"].count
    assert_equal 8, body["availabilities"]["2013-12-24"][0]["spots"]
    assert_equal 2, body["availabilities"]["2013-12-24"][1]["spots"]

    assert_equal 1, body["availabilities"]["2013-12-30"].count
    assert_equal 6, body["availabilities"]["2013-12-30"][0]["spots"]

    assert_equal 2, body["availabilities"]["2013-12-31"].count
    assert_equal 2, body["availabilities"]["2013-12-31"][0]["spots"]
    assert_equal 2, body["availabilities"]["2013-12-31"][1]["spots"]
  end

  test "query date range by activity" do
    sail = activities(:sail)
    scuba = activities(:scuba)

    # Query the right date gives a hit
    get :query, :format => :json, :from_date => "2013-12-22", :to_date => "2014-01-01", :activity_id => scuba.id
    assert_response :success
    body = JSON.parse(response.body)

    assert_equal 1, body["activities"].count

    assert_equal 2, body["availabilities"].keys.count

    assert_equal 1, body["availabilities"]["2013-12-24"].count
    assert_equal 2, body["availabilities"]["2013-12-24"][0]["spots"]

    assert_equal 1, body["availabilities"]["2013-12-31"].count
    assert_equal 2, body["availabilities"]["2013-12-31"][0]["spots"]
  end
end
