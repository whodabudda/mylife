class CreateMetrics < ActiveRecord::Migration
  def change
    create_table :metrics do |t|
      t.string :name
      t.string :description
      t.references :duser, index: true, foreign_key: true
      t.references :unit, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
