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
