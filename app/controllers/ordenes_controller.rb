class OrdenesController < ApplicationController
  before_action :ensure_vendedor!
  before_action :validar_permisos, only: [:show, :edit, :update, :destroy, :place]
	before_action :ensure_not_placed, only: [:edit, :update, :destroy]
  before_action :set_vendedor, only: [:index, :new, :edit]

  # GET /ordenes
  # GET /ordenes.json
  def index
    @ordenes = @vendedor ? Orden.por_vendedor(@vendedor.id) : Orden.all
		render layout: "dataTables"
  end

  # GET /ordenes/1
  # GET /ordenes/1.json
  def show
		@ordenes_cantidades = @orden.ordenes_cantidades
		render layout: "dataTables"
  end

  # GET /ordenes/new
  def new
    @orden = Orden.new
		set_options_for_selects(@vendedor)
  end

  # GET /ordenes/1/edit
  def edit
		set_options_for_selects(@vendedor)
  end

  # POST /ordenes
  # POST /ordenes.json
  def create
    @orden = Orden.new(orden_params)

    respond_to do |format|
      if current_user.tiene_permiso_sobre?(@orden) && @orden.save
        format.html { redirect_to @orden, notice: 'Orden was successfully created.' }
        format.json { render :show, status: :created, location: @orden }
      else
        format.html { render :new }
        format.json { render json: @orden.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ordenes/1
  # PATCH/PUT /ordenes/1.json
  def update
    respond_to do |format|
      if @orden.update(orden_params)
        format.html { redirect_to @orden, notice: 'Orden was successfully updated.' }
        format.json { render :show, status: :ok, location: @orden }
      else
        format.html { render :edit }
        format.json { render json: @orden.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ordenes/1
  # DELETE /ordenes/1.json
  def destroy
		@orden.destroy
	  respond_to do |format|
	    format.html { redirect_to ordenes_url, notice: 'Orden was successfully destroyed.' }
	    format.json { head :no_content }
	  end
  end

	def update_tiendas
		cliente = Cliente.find(params[:cliente_id])
		@tiendas_clientes = cliente.tiendas_clientes.map{|t| [t.nombre, t.id]}.insert(0, "Selecciona una tienda")
	end

  def place
		unless @orden.ordenes_cantidades.empty?
			@orden.update(fecha_pedido: Time.now)
			redirect_to @orden, notice: 'La orden fue completada exitosamente.'
		else
			redirect_to @orden, alert: 'No hay productos en la orden.'
		end
	end

	def asignar_repartidor
		ensure_admin!
		set_orden
		if @orden.fecha_pedido		
			@repartidores = Repartidor.all
		else
			redirect_to ordenes_url, alert: 'No puedes asignar una orden que no ha sido completada.'
		end
  end

  private
		def set_options_for_selects(vendedor)
			if vendedor
				@clientes = Cliente.con_tiendas.where(vendedor_id: vendedor.id)
				@tiendas_clientes = TiendaCliente.por_vendedor(vendedor.id)
			else
				@clientes = Cliente.con_tiendas
				@tiendas_clientes = TiendaCliente.all
			end
		end

		def validar_permisos
			set_orden
			unless current_user.tiene_permiso_sobre? @orden
				redirect_to ordenes_url, alert: 'No tienes los permisos necesarios.'
			end
		end

		def ensure_not_placed
			set_orden
			if @orden.fecha_pedido
				redirect_to orden_url(@orden), alert: 'No se puede alterar una orden que ya ha sido completada.'
			end
		end

		# Use callbacks to share common setup or constraints between actions.
    def set_orden
      @orden = Orden.find(params[:id])
    end

    def set_vendedor
			@vendedor = current_user.vendedor
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def orden_params
      params.require(:orden).permit(:fecha_entrega, :tienda_cliente_id, :repartidor_id)
    end
end
