json.array!(@repartidores) do |repartidor|
  json.extract! repartidor, :id, :nombre, :rfc, :telefono, :direccion
  json.url repartidor_url(repartidor, format: :json)
end
