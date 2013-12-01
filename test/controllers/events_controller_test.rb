require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  test "create" do
    activity = activities(:sail)
    schedule = schedules(:sail_xmas)

    post :create, :activity_id => activity.id,
      :date => schedule.date_at.strftime("%F"),
      :time => schedule.time_at_local.strftime("%R"),
      :spots => schedule.spots
    assert_response :created
  end

  test "create activity not found" do
    activity = activities(:sail)
    schedule = schedules(:sail_xmas)

    assert_raises(ActiveRecord::RecordNotFound) do
      post :create, :activity_id => 'x',
        :date => schedule.date_at.strftime("%F"),
        :time => schedule.time_at_local.strftime("%R"),
        :spots => schedule.spots
    end
  end

  test "create date incorrect" do
    activity = activities(:sail)
    schedule = schedules(:sail_xmas)

    post :create, :activity_id => activity.id,
      :date => (schedule.date_at + 1.day).strftime("%F"),
      :time => schedule.time_at_local.strftime("%R"),
      :spots => schedule.spots
    assert_response :forbidden
  end

  test "create time incorrect" do
    activity = activities(:sail)
    schedule = schedules(:sail_xmas)

    post :create, :activity_id => activity.id,
      :date => schedule.date_at.strftime("%F"),
      :time => (schedule.time_at_local + 1.hour).strftime("%R"),
      :spots => schedule.spots
    assert_response :forbidden
  end

  test "create spots not available" do
    activity = activities(:sail)
    schedule = schedules(:sail_new_years)

    post :create, :activity_id => activity.id,
      :date => schedule.date_at.strftime("%F"),
      :time => schedule.time_at_local.strftime("%R"),
      :spots => schedule.spots
    assert_response :conflict
  end
end
