class Baseline < ActiveRecord::Base
  after_initialize :default_values
  after_create :create_key
  belongs_to :suite
  default_scope { order(:created_at) }
  dragonfly_accessor :screenshot
  dragonfly_accessor :screenshot_baseline
  validates :name, :browser, :platform, :size, :suite, presence: true

  def create_thumbnails
    s = screenshot_thumbnail.url
    s = screenshot_baseline_thumbnail.url
  end

  def screenshot_thumbnail
    Thumbnail.new(screenshot)
  end

  def screenshot_baseline_thumbnail
    Thumbnail.new(screenshot_baseline)
  end
end
