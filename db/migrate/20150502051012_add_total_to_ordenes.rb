class AddTotalToOrdenes < ActiveRecord::Migration
  def change
	add_column :ordenes, :total, :decimal, precision: 11, scale: 2
	add_column :pedidos, :total, :decimal, precision: 11, scale: 2
  end
end
