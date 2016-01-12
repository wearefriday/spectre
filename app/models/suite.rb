class Suite < ActiveRecord::Base
  belongs_to :project
  has_many :runs
  has_many :tests, through: :runs
  after_initialize :create_slug

  def latest_run
    runs.reversed.first
  end

  def create_slug
    self.slug ||= name.parameterize
  end

  def baselines
    tests.where(baseline: true)
  end

  def to_param
    slug
  end
end
