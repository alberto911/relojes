json.array!(@proveedores) do |proveedor|
  json.extract! proveedor, :id, :nombre, :telefono, :direccion, :rfc
  json.url proveedor_url(proveedor, format: :json)
end
