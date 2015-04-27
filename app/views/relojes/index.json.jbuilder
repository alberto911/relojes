json.array!(@relojes) do |reloj|
  json.extract! reloj, :id, :marca, :modelo, :descripcion, :precio
  json.url reloj_url(reloj, format: :json)
end
