class RelojesController < ApplicationController
  before_action :ensure_admin!, except: [:index, :show]
	before_action :ensure_vendedor!, only: [:index, :show]
  before_action :set_reloj, only: [:show, :edit, :update, :destroy]

  # GET /relojes
  # GET /relojes.json
  def index
    @relojes = Reloj.all
		render layout: "dataTables"
  end

  # GET /relojes/1
  # GET /relojes/1.json
  def show
  end

  # GET /relojes/new
  def new
    @reloj = Reloj.new
  end

  # GET /relojes/1/edit
  def edit
  end

  # POST /relojes
  # POST /relojes.json
  def create
    @reloj = Reloj.new(reloj_params)

    respond_to do |format|
      if @reloj.save
        format.html { redirect_to @reloj, notice: 'Reloj was successfully created.' }
        format.json { render :show, status: :created, location: @reloj }
      else
        format.html { render :new }
        format.json { render json: @reloj.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /relojes/1
  # PATCH/PUT /relojes/1.json
  def update
    respond_to do |format|
      if @reloj.update(reloj_params)
        format.html { redirect_to @reloj, notice: 'Reloj was successfully updated.' }
        format.json { render :show, status: :ok, location: @reloj }
      else
        format.html { render :edit }
        format.json { render json: @reloj.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /relojes/1
  # DELETE /relojes/1.json
  def destroy
    @reloj.destroy
    respond_to do |format|
      format.html { redirect_to relojes_url, notice: 'Reloj was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reloj
      @reloj = Reloj.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reloj_params
      params.require(:reloj).permit(:marca, :modelo, :descripcion, :precio, :proveedor_id)
    end
end
