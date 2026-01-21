class Unit < ActiveRecord::Base
  #has_many :dusers , :through => :metrics
  belongs_to :duser
  has_many :metrics
  #
  #name of unit must be unique within the duser_id
  #TODO investigate the value of doing a cascading delete.
  #Right now, a delete of a Unit in use will orphan the using record.
  #
  #select all the units a user is authorized to view.  The views themselves will have to
  #manage what this user can edit in the unit.
  #
  scope :auth_to_view, ->(pduser_id) { where("units.duser_id in (?)",[pduser_id,Duser.system_user]).order(:duser_id,:name) }
  validate :unique_name_for_new, on: :create
  validate :unique_name_for_edit, on: :update

private

  def unique_name_for_new
    if Unit.exists?(name: name, duser_id: [duser_id, Duser.system_user])
      errors.add(:name, 'has already been taken')
    end
  end

  def unique_name_for_edit
    # when editing, if changing the name, make sure the new name doesn't exist
    if name_changed? && Unit.exists?(name: name, duser_id: [duser_id, Duser.system_user])
      errors.add(:name, 'has already been taken')
    end
  end
  #
  #validates_uniqueness_of :name within duser_id and system_user_id
  #Instead of copying all the system-defined Units and Metrics for the new user, will make
  #them available to all users, and check for uniqueness of name against both current_duser.id and 
  #system duser_id.
  #
=begin
  before_create :check_unique_name_for_new
  before_update :check_unique_name_for_edit
  def check_unique_name_for_new
    if Unit.select(:duser_id).where("name = ? and duser_id in (?)",self.name, [self.duser_id, Duser.system_user]).count > 0
     errors.add(:name, "has already been taken")
     raise ActiveRecord::RecordNotUnique.new(self)
    end
  end
  def check_unique_name_for_edit
    #when editing, if changing the name, make sure the new name doesn't exist
    if Unit.find(self.id).name != self.name
       check_unique_name_for_new
    end
  end
=end
end
