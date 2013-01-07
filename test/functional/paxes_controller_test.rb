require 'test_helper'

class PaxesControllerTest < ActionController::TestCase
  setup do
    @paxis = paxes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:paxes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create paxis" do
    assert_difference('Pax.count') do
      post :create, paxis: { end: @paxis.end, location: @paxis.location, name: @paxis.name, start: @paxis.start }
    end

    assert_redirected_to paxis_path(assigns(:paxis))
  end

  test "should show paxis" do
    get :show, id: @paxis
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @paxis
    assert_response :success
  end

  test "should update paxis" do
    put :update, id: @paxis, paxis: { end: @paxis.end, location: @paxis.location, name: @paxis.name, start: @paxis.start }
    assert_redirected_to paxis_path(assigns(:paxis))
  end

  test "should destroy paxis" do
    assert_difference('Pax.count', -1) do
      delete :destroy, id: @paxis
    end

    assert_redirected_to paxes_path
  end
end
