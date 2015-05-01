class Pedido < ActiveRecord::Base
	belongs_to :proveedor, inverse_of: :pedidos
	has_many :pedidos_cantidades, dependent: :destroy
	has_many :relojes, through: :pedidos_cantidades

	validates :proveedor_id, presence: true

	def recibido?
		!fecha_entrega.nil?
	end

	def total
	  	total = 0
		pedidos_cantidades.each do |pc|
			total += pc.subtotal
		end
		total
	end

end
