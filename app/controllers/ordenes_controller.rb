class OrdenesController < ApplicationController
  before_action :set_orden, only: [:show, :edit, :update, :destroy]

  # GET /ordenes
  # GET /ordenes.json
  def index
    @ordenes = Orden.all
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
		@clientes = Cliente.joins(:tiendas_clientes).distinct.order('nombre asc')
		@tiendas_clientes = TiendaCliente.all
  end

  # GET /ordenes/1/edit
  def edit
		@clientes = Cliente.joins(:tiendas_clientes).distinct.order('nombre asc')
		@tiendas_clientes = TiendaCliente.all
  end

  # POST /ordenes
  # POST /ordenes.json
  def create
    @orden = Orden.new(orden_params)

    respond_to do |format|
      if @orden.save
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_orden
      @orden = Orden.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def orden_params
      params.require(:orden).permit(:fecha_entrega, :tienda_cliente_id)
    end
end
