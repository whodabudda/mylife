class Role < ActiveRecord::Base
	has_many :dusers, :through => :duser_roles
	has_many :duser_roles
end
