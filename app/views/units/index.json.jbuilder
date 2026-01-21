json.array!(@units) do |unit|
  json.extract! unit, :id, :name, :displ_name, :duser_id
  json.url unit_url(unit, format: :json)
end
