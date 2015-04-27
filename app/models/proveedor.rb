class Proveedor < ActiveRecord::Base
	has_many :relojes, inverse_of: :proveedor, dependent: :destroy	
	
	validates :nombre, :telefono, :direccion, :rfc, presence: true
  validates :nombre, :telefono, :rfc, uniqueness: true  
	validates :nombre, :direccion, length: { maximum: 50 }
  validates :telefono, length: { in: 8..10 }, numericality: true
  validates :rfc, length: { is: 13 }
end
