class Repartidor < ActiveRecord::Base
	belongs_to :user, inverse_of: :repartidor, dependent: :destroy
	has_many :ordenes, inverse_of: :repartidor, dependent: :nullify

  validates :nombre, :telefono, :rfc, :direccion, presence: true
  validates :telefono, :rfc, uniqueness: true  
	validates :direccion, :nombre, length: { maximum: 50 }
  validates :telefono, length: { in: 8..10 }, numericality: true
  validates :rfc, length: { is: 13 }

	def entregas_pendientes
		ordenes.where(fecha_entrega: nil)
	end
end
