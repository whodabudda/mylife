class Metric < ActiveRecord::Base
  has_many :dusers , :through => :duser_metric
  has_many  :duser_metrics
  belongs_to :units
end
