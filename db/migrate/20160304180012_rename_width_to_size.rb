class RenameWidthToSize < ActiveRecord::Migration
  def change
    rename_column :tests, :width, :size
  end
end
