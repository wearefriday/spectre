class AddDiffThresholdToTest < ActiveRecord::Migration[5.0]
  def change
    add_column :tests, :diff_threshold, :float
  end
end
