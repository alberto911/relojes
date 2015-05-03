class ChangeToTimestamp < ActiveRecord::Migration
  def change
	change_column :ordenes, :fecha_pedido, :timestamp
	change_column :ordenes, :fecha_entrega, :timestamp
	change_column :pedidos, :fecha_pedido, :timestamp
	change_column :pedidos, :fecha_entrega, :timestamp
  end
end
