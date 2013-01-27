require 'test_helper'

class LoanersControllerTest < ActionController::TestCase
  setup do
    @loaner = loaners(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:loaners)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create loaner" do
    assert_difference('Loaner.count') do
      post :create, loaner: { contact: @loaner.contact, name: @loaner.name, phone_number: @loaner.phone_number }
    end

    assert_redirected_to loaner_path(assigns(:loaner))
  end

  test "should show loaner" do
    get :show, id: @loaner
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @loaner
    assert_response :success
  end

  test "should update loaner" do
    put :update, id: @loaner, loaner: { contact: @loaner.contact, name: @loaner.name, phone_number: @loaner.phone_number }
    assert_redirected_to loaner_path(assigns(:loaner))
  end

  test "should destroy loaner" do
    assert_difference('Loaner.count', -1) do
      delete :destroy, id: @loaner
    end

    assert_redirected_to loaners_path
  end
end
