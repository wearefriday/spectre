class Baseline < ActiveRecord::Base
  belongs_to :suite
  default_scope { order(:created_at) }
  dragonfly_accessor :screenshot
  validates :key, :name, :browser, :platform, :size, :suite, presence: true

  def create_thumbnails
    s = screenshot_thumbnail.url
    s = screenshot_baseline_thumbnail.url
  end

  def screenshot_thumbnail
    Thumbnail.new(screenshot)
  end

  def screenshot_url
    Rails.application.routes.url_helpers.baseline_path(key: self.key, format: 'png')
  end
end
