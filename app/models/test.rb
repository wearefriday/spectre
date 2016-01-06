class Test < ActiveRecord::Base
  after_initialize :default_values
  belongs_to :run
  default_scope { order('created_at ASC') }
  dragonfly_accessor :screenshot
  dragonfly_accessor :screenshot_baseline
  dragonfly_accessor :screenshot_diff
  validates :name, :browser, :platform, :width, :run, :screenshot, presence: true

  def self.find_by_key
    self.where("key = ?", key)
  end

  def self.find_baseline_by_key(key)
    self.where("key = ? AND baseline = ?", key, true).first
  end

  def create_key
    "#{run.suite.project.name} #{run.suite.name} #{name} #{browser} #{platform} #{width}".parameterize
  end

  def pass?
    pass
  end

  def url
    "#{run.url}#test_#{id}"
  end

  private
  def default_values
    self.diff ||= 0
    self.baseline ||= false
    self.dimensions_changed ||= false
    self.pass ||= false
  end
end
