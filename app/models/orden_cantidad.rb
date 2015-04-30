class OrdenCantidad < ActiveRecord::Base
	belongs_to :orden
	belongs_to :reloj

	validates :cantidad, :orden_id, :reloj_id, presence: true

	def subtotal 
		reloj.precio * cantidad
	end
	
end
