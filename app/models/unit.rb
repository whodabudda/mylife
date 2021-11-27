class Unit < ActiveRecord::Base
  has_many :metrics
  has_many :dusers , :through => :metrics
  belongs_to :duser
end
