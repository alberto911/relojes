class CreateOrdenes < ActiveRecord::Migration
  def change
    create_table :ordenes do |t|
      t.date :fecha_entrega
			t.integer :tienda_cliente_id, null: false
			t.integer :repartidor_id

      t.timestamps null: false
    end

		add_foreign_key :ordenes, :tiendas_clientes, name: 'fk_ordenes_tiendas'
		add_foreign_key :ordenes, :repartidores, name: 'fk_ordenes_repartidores'
  end
end
