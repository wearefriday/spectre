class RemovePlatform < ActiveRecord::Migration
  def change
    remove_column :tests, :platform, :string
    remove_column :baselines, :platform, :string
  end
end
