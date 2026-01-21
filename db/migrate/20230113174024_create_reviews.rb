class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.references :metric, foreign_key: true
      t.references :duser, foreign_key: true
      t.references :event, foreign_key: {to_table: :metrics}
#      t.integer :duser_id, references: :dusers,null: false
#      t.integer :metric_id, references: :metrics,null: false
#      t.integer :event_id, references: :metrics,null: false
      t.date :start_dt,null: false
      t.date :end_dt,null: false
      t.integer :span
      t.boolean :significant

      t.timestamps
    end
  end
  #add_reference :reviews, :event, references: :metrics
end
