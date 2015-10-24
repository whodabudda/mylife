class DuserRole < ActiveRecord::Base
	belongs_to :duser
	belongs_to :role
end
