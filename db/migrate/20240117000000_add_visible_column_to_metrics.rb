class AddVisibleColumnToMetrics < ActiveRecord::Migration[6.1]
  def change
    add_column :metrics, :visible, :boolean, default: true
  end
end

