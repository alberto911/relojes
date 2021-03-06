class TiendasClientesController < ApplicationController
  before_action :ensure_admin!, except: [:index, :show]
  before_action :ensure_vendedor!, only: [:index, :show]
  before_action :set_tienda_cliente, only: [:show, :edit, :update, :destroy]
  before_action :set_cliente, only: [:index, :new, :create]

  # GET /tiendas_clientes
  # GET /tiendas_clientes.json
  def index
		unless current_user.tiene_permiso_sobre? @cliente
			redirect_to clientes_url, alert: 'No tienes los permisos necesarios.'
		else
		  @tiendas_clientes = @cliente.tiendas_clientes
		  render layout: "dataTables"
    end
  end

  # GET /tiendas_clientes/1
  # GET /tiendas_clientes/1.json
  def show
		unless current_user.tiene_permiso_sobre? @tienda_cliente.cliente
			redirect_to clientes_url, alert: 'No tienes los permisos necesarios para ver esa tienda.'
		end
  end

  # GET /tiendas_clientes/new
  def new   
		@tienda_cliente = @cliente.tiendas_clientes.build
  end

  # GET /tiendas_clientes/1/edit
  def edit
  end

  # POST /tiendas_clientes
  # POST /tiendas_clientes.json
  def create   
		@tienda_cliente = @cliente.tiendas_clientes.build(tienda_cliente_params)

    respond_to do |format|
      if @tienda_cliente.save
        format.html { redirect_to @tienda_cliente, notice: 'La tienda se creó exitosamente.' }
        format.json { render :show, status: :created, location: @tienda_cliente }
      else
        format.html { render :new }
        format.json { render json: @tienda_cliente.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tiendas_clientes/1
  # PATCH/PUT /tiendas_clientes/1.json
  def update
    respond_to do |format|
      if @tienda_cliente.update(tienda_cliente_params)
        format.html { redirect_to @tienda_cliente, notice: 'La tienda se actualizó exitosamente.' }
        format.json { render :show, status: :ok, location: @tienda_cliente }
      else
        format.html { render :edit }
        format.json { render json: @tienda_cliente.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tiendas_clientes/1
  # DELETE /tiendas_clientes/1.json
  def destroy
		cliente = @tienda_cliente.cliente  
		if @tienda_cliente.destroy
      redirect_to cliente_tiendas_clientes_url(cliente), notice: 'La tienda se borró exitosamente.'
    else
			@tienda_cliente.update(activo: false)
			redirect_to cliente_tiendas_clientes_url(cliente), notice: 'La tienda se ha desactivado.'
		end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tienda_cliente
      @tienda_cliente = TiendaCliente.find(params[:id])
    end

		def set_cliente
			@cliente = Cliente.find(params[:cliente_id])
		end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tienda_cliente_params
      params.require(:tienda_cliente).permit(:nombre, :direccion, :telefono)
    end
end
