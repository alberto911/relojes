json.array!(@tiendas_clientes) do |tienda_cliente|
  json.extract! tienda_cliente, :id, :nombre, :direccion, :telefono
  json.url tienda_cliente_url(tienda_cliente, format: :json)
end
