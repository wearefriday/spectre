# frozen_string_literal: true

class AddHighlightColourToTest < ActiveRecord::Migration
  def change
    add_column :tests, :highlight_colour, :string
  end
end
