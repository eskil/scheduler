require 'test_helper'

class SchedulesControllerTest < ActionController::TestCase
  test "create with date" do
    activity = activities(:sail)
    n = activity.schedules.count

    post :create, :format => :json, :activity_id => activity.id,
      :date => "2013-12-24", :time => "13:00", :spots => 8,
      :price_cents => 13000, :price_currency => 'USD'

    assert_response :success
    assert_not_nil assigns(:schedule)

    activity.reload
    assert_equal n+1, activity.schedules.count

    schedule = activity.schedules.last
    assert_equal 13.hours.seconds, schedule.time_at
    assert_equal Date.parse("2013-12-24"), schedule.date_at
    assert_equal 8, schedule.spots
  end

  test "create recurring" do
    activity = activities(:sail)
    n = activity.schedules.count

    post :create, :format => :json, :activity_id => activity.id,
      :recurring => "mon tue fri", :time => "13:00", :spots => 8,
      :price_cents => 13000, :price_currency => 'USD'

    assert_response :success
    assert_not_nil assigns(:schedule)

    activity.reload
    assert_equal n+1, activity.schedules.count

    schedule = activity.schedules.last
    assert_equal 13.hours.seconds, schedule.time_at
    assert_equal 8, schedule.spots
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
        :date => "2013-12-24", :time => "13:00", :spots => 8,
        :price_cents => 13000, :price_currency => 'USD'
    end
  end

  test "destroy" do
    activity = activities(:sail)
    schedule = activity.schedules.first
    n = activity.schedules.count

    delete :destroy, :format => :json, :id => schedule.id
    assert_response :success

    activity.reload
    assert_equal n-1, activity.schedules.count
    assert_equal false, (activity.schedules.include? schedule)
  end

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
