# frozen_string_literal: true

class AddUrlToTests < ActiveRecord::Migration
  def change
    add_column :tests, :url, :string
  end
end
