class Review < ApplicationRecord
  belongs_to :metric
  belongs_to :event, class_name: 'Metric'
  belongs_to :duser
  validates :metric_id, :event_id, :duser_id,:span, presence: true, numericality: { only_integer: true,  greater_than: 0 }
  validates :start_dt, :end_dt, presence: true
  validate :end_date_after_start_date?

def end_date_after_start_date?
  return if end_dt.nil? or start_dt.nil?
  if  ((end_dt - start_dt).to_i < 14)
    Rails.logger.info "end_date_after_start_date?  validation failed "
    errors.add(:end_dt, "period of review must be a minimum of 2 weeks")
  end
  Rails.logger.info "Review Model: validate dates: " + start_dt.to_s + " " + end_dt.to_s
  true
end
end
