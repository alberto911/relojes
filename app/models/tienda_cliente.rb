class TiendaCliente < ActiveRecord::Base
	belongs_to :cliente, inverse_of: :tiendas_clientes
	has_many :ordenes, inverse_of: :tienda_cliente, dependent: :restrict_with_error

	validates :nombre, :telefono, :direccion, :cliente_id, presence: true  
	validates :nombre, :direccion, length: { maximum: 50 }
  validates :telefono, length: { in: 8..10 }, numericality: true

	default_scope { where(activo: true) }

	def cliente
		Cliente.unscoped.where(id: cliente_id).first
	end

	def self.por_vendedor(vendedor_id)
		TiendaCliente.joins(:cliente).where("clientes.vendedor_id = ?", vendedor_id)
	end
end
