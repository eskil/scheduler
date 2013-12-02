require 'test_helper'

class ActivitiesControllerTest < ActionController::TestCase
  test "index" do
    get :index
    assert_response :success
  end

  test "show" do
    get :show, :id => activities(:sail)
    assert_response :success
  end

  test "create" do
    post :create, :format => :json, :name => "name", :vendor => "vendor"
    assert_response :success
    assert_not_nil assigns(:activity)
  end

  ##
  # Scheduel events

  test "create schedule date" do
    activity = activities(:sail)
    n = activity.schedules.count

    post :schedule, :format => :json, :id => activity.id,
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

  test "create schedule recurring" do
    activity = activities(:sail)
    n = activity.schedules.count

    post :schedule, :format => :json, :id => activity.id,
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

  test "create schedule non existing id fails" do
    assert_raises(ActiveRecord::RecordNotFound) do
      post :schedule, :format => :json, :id => 'x',
        :date => "2013-12-24", :time => "13:00", :spots => 8,
        :price_cents => 13000, :price_currency => 'USD'
    end
  end

  test "destroy schedule" do
    activity = activities(:sail)
    schedule = activity.schedules.first
    n = activity.schedules.count

    delete :unschedule, :format => :json, :id => activity.id,
      :schedule_id => schedule.id
    assert_response :success

    activity.reload
    assert_equal n-1, activity.schedules.count
    assert_equal false, (activity.schedules.include? schedule)
  end

  ##
  # Book

  test "book via date" do
    activity = activities(:sail)
    schedule = schedules(:sail_xmas)

    post :book, :id => activity.id,
      :date => schedule.date_at.strftime("%F"),
      :time => schedule.time_at_local.strftime("%R"),
      :spots => schedule.spots
    assert_response :created
  end

  test "book via recurring" do
    activity = activities(:sail)
    schedule = schedules(:sail_mondays)

    post :book, :id => activity.id,
      :date => "2013-12-23",
      :time => schedule.time_at_local.strftime("%R"),
      :spots => schedule.spots
    assert_response :created
  end

  test "book activity not found" do
    activity = activities(:sail)
    schedule = schedules(:sail_xmas)

    assert_raises(ActiveRecord::RecordNotFound) do
      post :book, :id => 'x',
        :date => schedule.date_at.strftime("%F"),
        :time => schedule.time_at_local.strftime("%R"),
        :spots => schedule.spots
    end
  end

  test "book date not available" do
    activity = activities(:sail)
    schedule = schedules(:sail_xmas)

    post :book, :id => activity.id,
      :date => (schedule.date_at + 1.day).strftime("%F"),
      :time => schedule.time_at_local.strftime("%R"),
      :spots => schedule.spots
    assert_response :forbidden
  end

  test "book time not available" do
    activity = activities(:sail)
    schedule = schedules(:sail_xmas)

    post :book, :id => activity.id,
      :date => schedule.date_at.strftime("%F"),
      :time => (schedule.time_at_local + 1.hour).strftime("%R"),
      :spots => schedule.spots
    assert_response :forbidden
  end

  test "book spots not available" do
    activity = activities(:sail)
    schedule = schedules(:sail_new_years)

    post :book, :id => activity.id,
      :date => schedule.date_at.strftime("%F"),
      :time => schedule.time_at_local.strftime("%R"),
      :spots => schedule.spots
    assert_response :conflict
  end
end
