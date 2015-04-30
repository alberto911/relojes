class OrdenesCantidadesController < ApplicationController
  before_action :set_orden_cantidad, only: [:show, :edit, :update, :destroy]
  before_action :set_orden, only: [:index, :new, :create, :edit, :update, :destroy]
  respond_to :html, :js

  # GET /ordenes_cantidades
  # GET /ordenes_cantidades.json
  def index
    @ordenes_cantidades = @orden.ordenes_cantidades
		render layout: "dataTables"
  end

  # GET /ordenes_cantidades/1
  # GET /ordenes_cantidades/1.json
  def show
  end

  # GET /ordenes_cantidades/new
  def new
    @orden_cantidad = @orden.ordenes_cantidades.build
		@proveedores = Proveedor.joins(:relojes).distinct.order('nombre asc')
		@relojes = Reloj.all
  end

  # GET /ordenes_cantidades/1/edit
  def edit
		@proveedores = Proveedor.joins(:relojes).distinct.order('nombre asc')
		@relojes = Reloj.all
  end

  # POST /ordenes_cantidades
  # POST /ordenes_cantidades.json
  def create
		@ordenes_cantidades = @orden.ordenes_cantidades
    @orden_cantidad = @ordenes_cantidades.create(orden_cantidad_params)

    #respond_to do |format|
      #if @orden_cantidad.save
        #format.html { redirect_to @orden_cantidad, notice: 'Orden cantidad was successfully created.' }
        #format.json { render :show, status: :created, location: @orden_cantidad }
      #else
        #format.html { render :new }
        #format.json { render json: @orden_cantidad.errors, status: :unprocessable_entity }
      #end
    #end
  end

  # PATCH/PUT /ordenes_cantidades/1
  # PATCH/PUT /ordenes_cantidades/1.json
  def update
		@ordenes_cantidades = @orden.ordenes_cantidades
		@orden_cantidad.update_attributes(orden_cantidad_params)

    #respond_to do |format|
      #if @orden_cantidad.update(orden_cantidad_params)
        #format.html { redirect_to @orden_cantidad, notice: 'Orden cantidad was successfully updated.' }
        #format.json { render :show, status: :ok, location: @orden_cantidad }
      #else
        #format.html { render :edit }
        #format.json { render json: @orden_cantidad.errors, status: :unprocessable_entity }
      #end
    #end
  end

  # DELETE /ordenes_cantidades/1
  # DELETE /ordenes_cantidades/1.json
  def destroy
		@ordenes_cantidades = @orden.ordenes_cantidades
    @orden_cantidad.destroy
    #respond_to do |format|
      #format.html { redirect_to orden_ordenes_cantidades_url(params[:orden_id]), notice: 'Orden cantidad was successfully destroyed.' }
      #format.json { head :no_content }
    #end
  end

	def update_relojes
		proveedor = Proveedor.find(params[:proveedor_id])
		@relojes = proveedor.relojes.map{|r| [r.modelo, r.id]}.insert(0, "Selecciona un reloj")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_orden_cantidad
      @orden_cantidad = OrdenCantidad.find(params[:id])
    end

		def set_orden
			@orden = Orden.find(params[:orden_id])
		end

    # Never trust parameters from the scary internet, only allow the white list through.
    def orden_cantidad_params
      params.require(:orden_cantidad).permit(:cantidad, :reloj_id)
    end
end