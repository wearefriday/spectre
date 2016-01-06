class Suite < ActiveRecord::Base
  belongs_to :project
  has_many :runs
  has_many :tests, through: :runs

  def latest_run
    runs.reversed.first
  end

  def baselines
    tests.where(baseline: true)
  end

  def to_param
    slug
  end
end
