# frozen_string_literal: true

class RemoveRunsSequenceFromSuites < ActiveRecord::Migration
  def change
    remove_column :suites, :runs_sequence, :integer
  end
end
