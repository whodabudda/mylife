class ChangeUsers < ActiveRecord::Migration
  def change
	reversible do |dir|	
		dir.up do
    		change_column :users, :first_name, :string, :limit => 30
		    change_column :users, :last_name, :string, :limit => 50
		    change_column_null :users, :first_name, false
		    change_column_null :users, :last_name, false
		end
		dir.down do
    		change_column :users, :first_name, :string, :limit => nil
		    change_column :users, :last_name, :string, :limit => nil
		    change_column_null :users, :first_name, true
		    change_column_null :users, :last_name, true
		end
	end
    add_column :users, :email, :string, null: false, :limit => 255 
    add_column :users, :username, :string, null: false, :limit => 255 
  end
end
