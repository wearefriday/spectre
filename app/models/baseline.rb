# frozen_string_literal: true

class Baseline < ActiveRecord::Base
  after_save :create_thumbnails
  after_destroy :delete_thumbnails
  belongs_to :suite
  default_scope { order(:created_at) }
  dragonfly_accessor :screenshot
  validates :key, :name, :browser, :size, :suite, presence: true

  def create_thumbnails
    delete_thumbnails # remove any existing thumbnail for when baselines change
    s = screenshot_thumbnail.url
  end

  def delete_thumbnails
    screenshot_thumbnail.delete
  end

  def screenshot_thumbnail
    Thumbnail.new(screenshot, "#{key}_baseline")
  end

  def screenshot_url
    Rails.application.routes.url_helpers.baseline_path(key: key, format: 'png')
  end
end
