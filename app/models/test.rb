class Test < ActiveRecord::Base
  after_initialize :default_values
  after_create :create_key
  after_save :update_baseline
  belongs_to :run
  default_scope { order(:created_at) }
  dragonfly_accessor :screenshot
  dragonfly_accessor :screenshot_baseline
  dragonfly_accessor :screenshot_diff
  validates :name, :browser, :size, :run, presence: true

  def self.find_by_key
    where(key: key)
  end

  def self.find_last_five_by_key(key)
    where(key: key).unscoped.order(created_at: :desc).limit(5)
  end

  def as_json(options)
    run = super(options)
    run[:url] = self.url
    return run
  end

  def pass?
    pass
  end

  def baseline?
    Baseline.exists?(key: self.key, test_id: id)
  end

  def baseline
    Baseline.where(key: self.key).first
  end

  def url
    "#{run.url}#test_#{id}"
  end

  def create_key
    self.key = "#{run.suite.project.name} #{run.suite.name} #{name} #{browser} #{size}".parameterize
    self.save
  end

  def create_thumbnails
    s = screenshot_thumbnail.url
    s = screenshot_baseline_thumbnail.url
    s = screenshot_diff_thumbnail.url
  end

  def screenshot_thumbnail
    Thumbnail.new(screenshot)
  end

  def screenshot_baseline_thumbnail
    Thumbnail.new(screenshot_baseline)
  end

  def screenshot_diff_thumbnail
    Thumbnail.new(screenshot_diff)
  end

  def five_consecutive_failures
    previous_tests = Test.find_last_five_by_key(key)
    return false if previous_tests.length < 5
    previous_tests.all? { |t| t.pass == false }
  end

  private

  def default_values
    self.diff ||= 0
    self.pass ||= false
    self.fuzz_level = '30%' if self.fuzz_level.blank?
  end

  def update_baseline
    return unless self.pass
    Baseline.find_or_initialize_by(key: self.key).update_attributes!(
      key: self.key,
      name: self.name,
      browser: self.browser,
      size: self.size,
      suite: self.run.suite,
      screenshot: self.screenshot,
      test_id: self.id
    )
  end
end
