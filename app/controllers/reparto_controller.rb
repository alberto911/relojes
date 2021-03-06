class RepartoController < ApplicationController
	before_action :ensure_repartidor!

	def index
		if current_user.is_admin
			redirect_to ordenes_url
		else
			@direcciones = Orden.por_entregar(current_user.repartidor.id)
			@ordenes = current_user.repartidor.entregas_pendientes
			render layout: "dataTables"
		end
	end
end
