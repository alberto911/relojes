class Pedido < ActiveRecord::Base
	belongs_to :proveedor, inverse_of: :pedidos
	has_many :pedidos_cantidades
	has_many :relojes, through: :pedidos_cantidades

	validates :proveedor_id, presence: true

	def recibido?
		!fecha_entrega.nil?
	end
end
