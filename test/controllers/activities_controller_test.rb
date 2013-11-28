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
    post :create, :name => "name", :vendor => "vendor"
    assert_response :success
    assert_not_nil assigns(:activity)
  end
end
