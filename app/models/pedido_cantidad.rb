class PedidoCantidad < ActiveRecord::Base
	belongs_to :pedido
	belongs_to :reloj

	validates :cantidad, :pedido_id, :reloj_id, presence: true
  validates :cantidad, numericality: { only_integer: true, greater_than: 0}

	def subtotal 
		reloj.costo * cantidad
	end
end
