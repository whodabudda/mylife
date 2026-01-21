class CreateIndex < ActiveRecord::Migration
	def self.up
		add_index :dusers_roles, [:dusers_id, :roles_id]
		add_index :dusers_roles, :dusers_id
	end

	def self.down
		remove_index :dusers_roles, [:dusers_id, :roles_id]
		remove_index :dusers_roles, :dusers_id

	end
end
