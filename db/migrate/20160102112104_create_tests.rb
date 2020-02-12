# frozen_string_literal: true

class CreateTests < ActiveRecord::Migration
  def change
    create_table :tests do |t|
      t.string :name
      t.string :browser
      t.string :platform
      t.string :width
      t.references :run, index: true, foreign_key: true
      t.boolean :baseline
      t.float :diff

      t.timestamps null: false
    end
  end
end
