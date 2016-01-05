class RemoveScopedIdFromRuns < ActiveRecord::Migration
  def change
    remove_column :runs, :scoped_id, :integer
  end
end
