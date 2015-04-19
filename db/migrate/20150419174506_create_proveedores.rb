class CreateProveedores < ActiveRecord::Migration
  def change
    create_table :proveedores do |t|
      t.string :nombre, null: false, unique: true
      t.string :telefono, null: false, unique: true
      t.string :direccion, null: false
      t.string :rfc, null: false, unique: true

      t.timestamps null: false
    end
  end
end
