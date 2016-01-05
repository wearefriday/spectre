class AddPassToTests < ActiveRecord::Migration
  def change
    add_column :tests, :pass, :boolean
  end
end
