class PedidosCantidadesController < ApplicationController
  before_action :set_pedido_cantidad, only: [:edit, :update, :destroy]
  before_action :set_pedido
  respond_to :html, :js

  # GET /pedidos_cantidades
  # GET /pedidos_cantidades.json
  def index
    @pedidos_cantidades = @pedido.pedidos_cantidades
		render layout: "dataTables"
  end

  # GET /pedidos_cantidades/new
  def new
    @pedido_cantidad = @pedido.pedidos_cantidades.build
		@relojes = @pedido.proveedor.relojes
  end

  # GET /pedidos_cantidades/1/edit
  def edit
		@relojes = @pedido.proveedor.relojes
  end

  # POST /pedidos_cantidades
  # POST /pedidos_cantidades.json
  def create
		@pedidos_cantidades = @pedido.pedidos_cantidades
    @pedido_cantidad = @pedidos_cantidades.create(pedido_cantidad_params)

    #respond_to do |format|
      #if @pedido_cantidad.save
        #format.html { redirect_to @pedido_cantidad, notice: 'Pedido cantidad was successfully created.' }
        #format.json { render :show, status: :created, location: @pedido_cantidad }
      #else
        #format.html { render :new }
        #format.json { render json: @pedido_cantidad.errors, status: :unprocessable_entity }
      #end
    #end
  end

  # PATCH/PUT /pedidos_cantidades/1
  # PATCH/PUT /pedidos_cantidades/1.json
  def update
		@pedidos_cantidades = @pedido.pedidos_cantidades
		@pedido_cantidad.update_attributes(pedido_cantidad_params)

    #respond_to do |format|
      #if @pedido_cantidad.update(pedido_cantidad_params)
        #format.html { redirect_to @pedido_cantidad, notice: 'Pedido cantidad was successfully updated.' }
        #format.json { render :show, status: :ok, location: @pedido_cantidad }
      #else
        #format.html { render :edit }
        #format.json { render json: @pedido_cantidad.errors, status: :unprocessable_entity }
      #end
    #end
  end

  # DELETE /pedidos_cantidades/1
  # DELETE /pedidos_cantidades/1.json
  def destroy
		@pedidos_cantidades = @pedido.pedidos_cantidades
    @pedido_cantidad.destroy
    #respond_to do |format|
      #format.html { redirect_to pedido_pedidos_cantidades_url(params[:pedido_id]), notice: 'Pedido cantidad was successfully destroyed.' }
      #format.json { head :no_content }
    #end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pedido_cantidad
      @pedido_cantidad = PedidoCantidad.find(params[:id])
    end

		def set_pedido
			@pedido = Pedido.find(params[:pedido_id])
		end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pedido_cantidad_params
      params.require(:pedido_cantidad).permit(:cantidad, :reloj_id)
    end
end
