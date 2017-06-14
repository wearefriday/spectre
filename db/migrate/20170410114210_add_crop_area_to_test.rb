class AddCropAreaToTest < ActiveRecord::Migration
  def change
    add_column :tests, :crop_area, :string
  end
end
