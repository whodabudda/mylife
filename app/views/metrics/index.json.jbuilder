json.array!(@metrics) do |metric|
  json.extract! metric, :id, :name, :description, :duser_id, :unit_id
  json.url metric_url(metric, format: :json)
end
