json.array!(@ordenes) do |orden|
  json.extract! orden, :id, :fecha_pedido, :fecha_entrega
  json.url orden_url(orden, format: :json)
end
