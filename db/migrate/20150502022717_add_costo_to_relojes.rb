class AddCostoToRelojes < ActiveRecord::Migration
  def change
	add_column :relojes, :costo, :decimal, precision: 8, scale: 2, null: false, default: 0
	add_column :relojes, :activo, :boolean, default: true
  end
end
