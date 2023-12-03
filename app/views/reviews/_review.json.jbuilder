json.extract! review, :id, :metric_id, :event_id, :duser_id, :start_dt, :end_dt, :span, :significant, :created_at, :updated_at
json.url review_url(review, format: :json)
