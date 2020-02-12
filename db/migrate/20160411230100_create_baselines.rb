# frozen_string_literal: true

class CreateBaselines < ActiveRecord::Migration
  def change
    create_table :baselines do |t|
      t.string :name
      t.string :browser
      t.string :platform
      t.string :size
      t.references :suite, index: true, foreign_key: true
      t.string :screenshot_uid

      t.timestamps null: false
    end
  end
end
