class Orden < ActiveRecord::Base
	belongs_to :tienda_cliente, inverse_of: :ordenes
	belongs_to :repartidor, inverse_of: :ordenes
	has_many :ordenes_cantidades
	has_many :relojes, through: :ordenes_cantidades

	validates :tienda_cliente_id, presence: true
end
