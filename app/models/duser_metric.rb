class DuserMetric < ActiveRecord::Base
  belongs_to :duser
  belongs_to :unit
  belongs_to :metric
  scope :for_duser, ->(pduser_id) { where("duser_id = ?",pduser_id) }
  scope :for_series, ->(pmetric_id) { where("metric_id = ?",pmetric_id) }
  def unit_name
  	Rails.logger.info "In unit_name"
    Unit.find(self.metric.unit_id).name
  end
end
