class Cliente < ActiveRecord::Base
	belongs_to :vendedor, inverse_of: :clientes
  has_many :tiendas_clientes, inverse_of: :cliente, dependent: :destroy

	validates :nombre, :telefono, :direccion_fiscal, :rfc, :vendedor_id, presence: true
  validates :nombre, :telefono, :rfc, uniqueness: true  
	validates :nombre, :direccion_fiscal, length: { maximum: 50 }
  validates :telefono, length: { in: 8..10 }, numericality: true
  validates :rfc, length: { is: 13 }

	def self.con_tiendas
		Cliente.joins(:tiendas_clientes).distinct.order('nombre asc')
	end
end
