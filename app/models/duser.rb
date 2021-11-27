
class Duser < ActiveRecord::Base
	has_many :duser_roles
	has_many :duser_metrics
	has_many :metrics , :through => :duser_metrics
	has_many :roles , :through => :duser_roles
	has_many :units
	@SystemUser = 1
  	#before_create :set_default_role
	before_save :check_username

	def self.system_user?(this_user)
		this_user == @SystemUser
	end
	def system_user
		@SystemUser	
	end

	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	         :recoverable, :rememberable, :trackable, :validatable, :lockable

 	private
	def set_default_role
	    self.role ||= Role.find_by_name('user')
	end

	def check_username
		if self.username == ""
			self.username = self.email
		end
	end
end
