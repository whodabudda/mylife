class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.string :name
      t.string :displ_name
      t.references :duser, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
