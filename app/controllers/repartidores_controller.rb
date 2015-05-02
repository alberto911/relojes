class RepartidoresController < ApplicationController
  before_action :ensure_admin!
  before_action :set_repartidor, only: [:show, :edit, :update, :destroy]

  # GET /repartidores
  # GET /repartidores.json
  def index
    @repartidores = Repartidor.all
		render layout: "dataTables"
  end

  # GET /repartidores/1
  # GET /repartidores/1.json
  def show
  end

  # GET /repartidores/new
  def new
    @repartidor = Repartidor.new
  end

  # GET /repartidores/1/edit
  def edit
  end

  # POST /repartidores
  # POST /repartidores.json
  def create
    user = User.new(user_params)
		@repartidor = Repartidor.new(repartidor_params)

		unless @repartidor.valid?
			render :new
		else
			if user.save
		    @repartidor.user_id = user.id
				  if @repartidor.save
				    redirect_to @repartidor, notice: 'El repartidor se creó exitosamente.'
				  else
				    render :new
				  end
			else
				flash[:alert] = user.errors.full_messages.first
				redirect_to :action => :new
			end
		end
  end

  # PATCH/PUT /repartidores/1
  # PATCH/PUT /repartidores/1.json
  def update
    user = User.find(@repartidor.user_id)
    if @repartidor.update(repartidor_params) && user.update(user_params)
			sign_in(current_user, :bypass => true)
      redirect_to @repartidor, notice: 'El repartidor se actualizó exitosamente.'
    else
			flash[:alert] = user.errors.full_messages.first
      render :edit
    end
  end

  # DELETE /repartidores/1
  # DELETE /repartidores/1.json
  def destroy
    @repartidor.destroy
    respond_to do |format|
      format.html { redirect_to repartidores_url, notice: 'El repartidor se borró exitosamente.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_repartidor
      @repartidor = Repartidor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def repartidor_params
      params.require(:repartidor).permit(:nombre, :rfc, :telefono, :direccion)
    end

		def user_params
			if params[:user][:password].present?			
				params.require(:user).permit(:email, :password)
			else
				params.require(:user).permit(:email)
			end
		end
end
