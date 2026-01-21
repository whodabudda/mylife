class AddSeriesColorColumnToMetrics < ActiveRecord::Migration
  def change
    add_column :metrics, :series_color, :string
  end
end
