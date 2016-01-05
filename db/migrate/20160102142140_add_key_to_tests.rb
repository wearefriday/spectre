class AddKeyToTests < ActiveRecord::Migration
  def change
    add_column :tests, :key, :string
  end
end
