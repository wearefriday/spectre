# frozen_string_literal: true

class AddKeyToBaselines < ActiveRecord::Migration
  def change
    add_column :baselines, :key, :string
  end
end
