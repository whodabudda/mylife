class Metric < ActiveRecord::Base
  has_many :duser_metrics , dependent: :delete_all
  has_many :reviews , foreign_key: :metric_id, dependent: :delete_all
  has_many :reviews , foreign_key: :event_id, dependent: :delete_all
  has_many :dusers , :through => :duser_metrics
  belongs_to :unit
  belongs_to :duser
  #validates :duser_id, :unit_id, presence: true, numericality: { only_integer: true,  greater_than: 0 }
  validates :series_type, presence: true ,inclusion: { in: %w(metric event)}
  scope :auth_to_view, ->(pduser_id) { where("duser_id in (?)",[pduser_id,Duser.system_user]).order(:duser_id, :name) }
  #validates_uniqueness_of :name, scope: :duser_id
  validate :unique_name_for_new, on: :create

  validate :unique_name_for_edit, on: :update

  def unique_name_for_new
    if Metric.exists?(name: name, duser_id: [duser_id, Duser.system_user])
      errors.add(:name, 'has already been taken')
    end
  end

  def unique_name_for_edit
    # when editing, if changing the name, make sure the new name doesn't exist
    if name_changed? && Metric.exists?(name: name, duser_id: [duser_id, Duser.system_user])
      errors.add(:name, 'is already in use')
     # Rails.logger.info ("Metric.rb - Duplicate name. Should fail to update.") 
     # raise ActiveRecord::RecordNotUnique
    end
  end

=begin 
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
=end
end
