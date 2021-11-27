class Metric < ActiveRecord::Base
  has_many :duser_metrics
  has_many :dusers , :through => :duser_metrics
  belongs_to :duser
  belongs_to :unit 
end
