json.array!(@vendedores) do |vendedor|
  json.extract! vendedor, :id, :nombre, :telefono, :rfc
  json.url vendedor_url(vendedor, format: :json)
end
