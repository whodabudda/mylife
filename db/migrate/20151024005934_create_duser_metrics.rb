class CreateDuserMetrics < ActiveRecord::Migration
  def change
    create_table :duser_metrics , :id => false do |t|
      t.integer :value
      t.datetime :occur_dttm
      t.references :duser, index: true, foreign_key: true
      t.references :metric, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
