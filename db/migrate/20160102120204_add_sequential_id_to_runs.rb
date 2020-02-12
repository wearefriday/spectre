# frozen_string_literal: true

class AddSequentialIdToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :sequential_id, :integer
  end
end
