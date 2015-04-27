class CreateVendedores < ActiveRecord::Migration
  def change
    create_table :vendedores do |t|
      t.string :nombre
      t.string :telefono
      t.string :rfc
      t.integer :user_id

      t.timestamps null: false
    end
		
		add_foreign_key :vendedores, :users, name: 'fk_vendedores_usuarios'
  end
end
