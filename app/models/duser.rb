
class Duser < ActiveRecord::Base
	has_many :duser_roles, dependent: :delete_all
	has_many :duser_metrics , dependent: :delete_all
	has_many :metrics , :through => :duser_metrics , dependent: :delete_all
	has_many :roles , :through => :duser_roles , dependent: :delete_all
	has_many :units , dependent: :delete_all
	has_many :reviews , dependent: :delete_all
	#scope :for_duser, ->(pduser_id) { where("duser_id = ?",pduser_id) }

	#email is already validated for uniqueness by Devise
	validates :username, presence: true, uniqueness: { case_sensitive: false }
	
	@SystemUser = 1
  	#before_create :set_default_role
	before_save :check_username

	def self.system_user?(this_user)
		this_user == @SystemUser
	end

	def self.system_user
		@SystemUser	
	end

	def self.auth?(saved_id, current_id)
		if(saved_id == current_id or self.system_user?(current_id) )
			true
		else
			false
		end
	end
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	         :recoverable, :rememberable, :trackable, :validatable, :lockable

 	private

	def set_default_role
	    self.role ||= Role.find_by_name('duser')
	end

	def check_username
	 self.username = self.email if self.username.blank? && new_record?
	#self.username = self.email if self.username.nil? || self.username.blank?

	end
end
