class Duser < ActiveRecord::Base
	has_and_belongs_to_many :roles
  	#before_create :set_default_role
	before_save :check_username


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
