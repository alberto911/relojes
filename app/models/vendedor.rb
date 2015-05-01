class Vendedor < ActiveRecord::Base
	belongs_to :user, inverse_of: :vendedor, dependent: :destroy
	has_many :clientes, inverse_of: :vendedor, dependent: :restrict_with_error

  validates :nombre, :telefono, :rfc, presence: true
  validates :telefono, :rfc, uniqueness: true  
	validates :nombre, length: { maximum: 50 }
  validates :telefono, length: { in: 8..10 }, numericality: true
  validates :rfc, length: { is: 13 }
end
