# frozen_string_literal: true

class RemoveBaselineFromTests < ActiveRecord::Migration
  def change
    remove_column :tests, :baseline, :boolean
  end
end
