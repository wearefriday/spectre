class AddTestIdToBaselines < ActiveRecord::Migration
  def change
    add_column :baselines, :test_id, :integer
  end
end
