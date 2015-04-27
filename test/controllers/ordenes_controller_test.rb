require 'test_helper'

class OrdenesControllerTest < ActionController::TestCase
  setup do
    @orden = ordenes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ordenes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create orden" do
    assert_difference('Orden.count') do
      post :create, orden: { fecha_entrega: @orden.fecha_entrega, fecha_pedido: @orden.fecha_pedido }
    end

    assert_redirected_to orden_path(assigns(:orden))
  end

  test "should show orden" do
    get :show, id: @orden
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @orden
    assert_response :success
  end

  test "should update orden" do
    patch :update, id: @orden, orden: { fecha_entrega: @orden.fecha_entrega, fecha_pedido: @orden.fecha_pedido }
    assert_redirected_to orden_path(assigns(:orden))
  end

  test "should destroy orden" do
    assert_difference('Orden.count', -1) do
      delete :destroy, id: @orden
    end

    assert_redirected_to ordenes_path
  end
end
