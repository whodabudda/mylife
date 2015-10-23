class AddColsToDusers < ActiveRecord::Migration
  def change
 	reversible do |dir|	
		dir.up do
    		
		end
		dir.down do

 		end
	end
    add_column :dusers, :username, :string, null: false, :limit => 255 
    add_column :dusers, :birthdate, :date, null: false 
  end
end
