class CreateTiendasClientes < ActiveRecord::Migration
  def change
    create_table :tiendas_clientes do |t|
      t.string :nombre, null: false, limit: 50
      t.string :direccion, null: false, limit: 50
      t.string :telefono, null: false, limit: 10
			t.integer :cliente_id, null: false

      t.timestamps null: false
    end

		add_foreign_key :tiendas_clientes, :clientes, name: 'fk_tiendas_clientes'
  end
end
