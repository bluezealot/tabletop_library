require 'test_helper'

class CheckoutsControllerTest < ActionController::TestCase
  setup do
    @checkout = checkouts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:checkouts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create checkout" do
    assert_difference('Checkout.count') do
      post :create, checkout: { attendee_id: @checkout.attendee_id, check_out_time: @checkout.check_out_time, closed: @checkout.closed, game_id: @checkout.game_id, pax_id: @checkout.pax_id, return_time: @checkout.return_time }
    end

    assert_redirected_to checkout_path(assigns(:checkout))
  end

  test "should show checkout" do
    get :show, id: @checkout
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @checkout
    assert_response :success
  end

  test "should update checkout" do
    put :update, id: @checkout, checkout: { attendee_id: @checkout.attendee_id, check_out_time: @checkout.check_out_time, closed: @checkout.closed, game_id: @checkout.game_id, pax_id: @checkout.pax_id, return_time: @checkout.return_time }
    assert_redirected_to checkout_path(assigns(:checkout))
  end

  test "should destroy checkout" do
    assert_difference('Checkout.count', -1) do
      delete :destroy, id: @checkout
    end

    assert_redirected_to checkouts_path
  end
end
