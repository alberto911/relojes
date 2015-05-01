class Orden < ActiveRecord::Base
	belongs_to :tienda_cliente, inverse_of: :ordenes
	belongs_to :repartidor, inverse_of: :ordenes
	has_many :ordenes_cantidades, dependent: :destroy
	has_many :relojes, through: :ordenes_cantidades

	validates :tienda_cliente_id, presence: true

	def self.por_vendedor(vendedor_id)
		Orden.joins("JOIN tiendas_clientes tc ON tc.id = ordenes.tienda_cliente_id JOIN clientes c ON c.id = tc.cliente_id").where("c.vendedor_id = ?", vendedor_id)
	end

  def vendedor
		tienda_cliente.cliente.vendedor
  end

	def total
	  	total = 0
		ordenes_cantidades.each do |oc|
			total += oc.subtotal
		end
		total
	end

	def entregada?
		!fecha_entrega.nil?
  end

	def tiene_repartidor?
		!repartidor.nil?
	end
end
