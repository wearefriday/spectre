class AddSequentialIdToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :sequential_id, :integer
  end
end
