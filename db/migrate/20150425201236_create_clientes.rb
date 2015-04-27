class CreateClientes < ActiveRecord::Migration
  def change
    create_table :clientes do |t|
      t.string :nombre, null: false, unique: true, limit: 50
      t.string :telefono, null: false, unique: true, limit: 10
      t.string :direccion_fiscal, null: false, limit: 50
      t.string :rfc, null: false, unique: true, limit: 13
			t.integer :vendedor_id, null: false

      t.timestamps null: false
    end

		add_foreign_key :clientes, :vendedores, name: 'fk_clientes_vendedores'
  end
end
