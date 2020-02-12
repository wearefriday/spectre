# frozen_string_literal: true

class AddTestIdToBaselines < ActiveRecord::Migration
  def change
    add_column :baselines, :test_id, :integer
  end
end
