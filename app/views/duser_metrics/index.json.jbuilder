json.array!(@duser_metrics) do |duser_metric|
  json.extract! duser_metric, :id, :value, :occur_dttm, :duser_id, :metric_id
  json.url duser_metric_url(duser_metric, format: :json)
end
