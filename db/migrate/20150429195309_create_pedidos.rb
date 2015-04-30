class CreatePedidos < ActiveRecord::Migration
  def change
    create_table :pedidos do |t|
      t.date :fecha_entrega
			t.integer :proveedor_id, null: false

      t.timestamps null: false
    end

		add_foreign_key :pedidos, :proveedores, name: 'fk_pedidos_proveedores'
  end
end
