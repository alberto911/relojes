require 'test_helper'

class TiendasClientesControllerTest < ActionController::TestCase
  setup do
    @tienda_cliente = tiendas_clientes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tiendas_clientes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tienda_cliente" do
    assert_difference('TiendaCliente.count') do
      post :create, tienda_cliente: { direccion: @tienda_cliente.direccion, nombre: @tienda_cliente.nombre, telefono: @tienda_cliente.telefono }
    end

    assert_redirected_to tienda_cliente_path(assigns(:tienda_cliente))
  end

  test "should show tienda_cliente" do
    get :show, id: @tienda_cliente
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tienda_cliente
    assert_response :success
  end

  test "should update tienda_cliente" do
    patch :update, id: @tienda_cliente, tienda_cliente: { direccion: @tienda_cliente.direccion, nombre: @tienda_cliente.nombre, telefono: @tienda_cliente.telefono }
    assert_redirected_to tienda_cliente_path(assigns(:tienda_cliente))
  end

  test "should destroy tienda_cliente" do
    assert_difference('TiendaCliente.count', -1) do
      delete :destroy, id: @tienda_cliente
    end

    assert_redirected_to tiendas_clientes_path
  end
end
