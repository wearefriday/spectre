# frozen_string_literal: true

class RemoveDimensionsChangedFromTests < ActiveRecord::Migration
  def change
    remove_column :tests, :dimensions_changed, :boolean
  end
end
