class DuserMetric < ActiveRecord::Base
  belongs_to :duser
  belongs_to :metric
end
