# frozen_string_literal: true

class CreateRuns < ActiveRecord::Migration
  def change
    create_table :runs do |t|
      t.integer :scoped_id
      t.references :suite, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
