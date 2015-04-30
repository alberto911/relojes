class PedidoCantidad < ActiveRecord::Base
	belongs_to :pedido
	belongs_to :reloj

	validates :cantidad, :pedido_id, :reloj_id, presence: true
end
