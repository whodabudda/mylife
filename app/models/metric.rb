class Metric < ActiveRecord::Base
  has_many :duser_metrics , dependent: :delete_all
  has_many :reviews , foreign_key: :metric_id, dependent: :delete_all
  has_many :reviews , foreign_key: :event_id, dependent: :delete_all
  has_many :dusers , :through => :duser_metrics
  belongs_to :duser
  belongs_to :unit 
  validates :duser_id, :unit_id, presence: true, numericality: { only_integer: true,  greater_than: 0 }
  validates :series_type, presence: true ,inclusion: { in: %w(metric event)}
  scope :auth_to_view, ->(pduser_id) { where("duser_id in (?)",[pduser_id,Duser.system_user]) }
  #validates_uniqueness_of :name, scope: :duser_id
  before_create :check_unique_name_for_new
  before_update :check_unique_name_for_edit
  def check_unique_name_for_new
    if Metric.select(:duser_id).where("name = ? and duser_id in (?)",self.name, [self.duser_id, 1]).count > 0 
     errors.add(:name, "already in use")
     raise ActiveRecord::RecordInvalid.new(self) #raise an error because just doing errors.add won't enforce rollback
    end
  end
  def check_unique_name_for_edit
    #when editing, if changing the name, make sure the new name doesn't exist
    if Metric.find(self.id).name != self.name
       check_unique_name_for_new
    end
  end
end
