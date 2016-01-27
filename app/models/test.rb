class Test < ActiveRecord::Base
  after_initialize :default_values
  after_create :create_key
  belongs_to :run
  default_scope { order('created_at ASC') }
  dragonfly_accessor :screenshot
  dragonfly_accessor :screenshot_baseline
  dragonfly_accessor :screenshot_diff
  validates :name, :browser, :platform, :width, :run, presence: true

  def self.find_by_key
    where(key: key)
  end

  def self.find_baseline_by_key(key)
    where(key: key, baseline: true).first
  end


  def pass?
    pass
  end

  def url
    "#{run.url}#test_#{id}"
  end

  def create_key
    self.key = "#{run.suite.project.name} #{run.suite.name} #{name} #{browser} #{platform} #{width}".parameterize
    self.save
  end

  private

  def default_values
    self.diff ||= 0
    self.baseline ||= false
    self.dimensions_changed ||= false
    self.pass ||= false
  end
end
