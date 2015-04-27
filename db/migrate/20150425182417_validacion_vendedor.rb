class ValidacionVendedor < ActiveRecord::Migration
  def change
		change_column :vendedores, :nombre, :string, null: false, limit: 50
		change_column :vendedores, :telefono, :string, null: false, limit: 10
    change_column :vendedores, :rfc, :string, null: false, limit: 13
		change_column :vendedores, :user_id, :integer, null: false
  end
end
