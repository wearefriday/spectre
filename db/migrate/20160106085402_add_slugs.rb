# frozen_string_literal: true

class AddSlugs < ActiveRecord::Migration
  def change
    add_column :projects, :slug, :string
    add_column :suites, :slug, :string
  end
end
