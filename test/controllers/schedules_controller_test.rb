require 'test_helper'

class SchedulesControllerTest < ActionController::TestCase
  test "create with date" do
    activity = activities(:sail)
    n = activity.schedules.count

    post :create, :format => :json, :activity_id => activity.id,
      :date => "2013-12-24", :time => "13:00", :slots => 8

    assert_response :success
    assert_not_nil assigns(:schedule)

    activity.reload
    assert_equal n+1, activity.schedules.count

    schedule = activity.schedules.last
    assert_equal false, schedule.recurring
    assert_equal 13.hours.seconds, schedule.time_at
    assert_equal Date.parse("2013-12-24"), schedule.date_at
    assert_equal 8, schedule.slots
  end

  test "create recurring" do
    activity = activities(:sail)
    n = activity.schedules.count

    post :create, :format => :json, :activity_id => activity.id,
      :recurring => "mon, tue, fri", :time => "13:00", :slots => 8

    assert_response :success
    assert_not_nil assigns(:schedule)

    activity.reload
    assert_equal n+1, activity.schedules.count

    schedule = activity.schedules.last
    assert_equal true, schedule.recurring
    assert_equal 13.hours.seconds, schedule.time_at
    assert_equal 8, schedule.slots
    assert_equal false, schedule.on_sun
    assert_equal true, schedule.on_mon
    assert_equal true, schedule.on_tue
    assert_equal false, schedule.on_wed
    assert_equal false, schedule.on_thu
    assert_equal true, schedule.on_fri
    assert_equal false, schedule.on_sat
  end

  test "create non existing id failse" do
    assert_raises(ActiveRecord::RecordNotFound) do
      post :create, :format => :json, :activity_id => 'x',
        :date => "2013-12-24", :time => "13:00", :slots => 8
    end
  end
end
