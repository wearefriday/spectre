# frozen_string_literal: true

class RenameUrl < ActiveRecord::Migration
  def change
    rename_column :tests, :url, :source_url
  end
end
