# frozen_string_literal: true

class RemoveScopedIdFromRuns < ActiveRecord::Migration
  def change
    remove_column :runs, :scoped_id, :integer
  end
end
