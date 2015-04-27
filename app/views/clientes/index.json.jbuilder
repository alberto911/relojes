json.array!(@clientes) do |cliente|
  json.extract! cliente, :id, :nombre, :telefono, :direccion_fiscal, :rfc
  json.url cliente_url(cliente, format: :json)
end
