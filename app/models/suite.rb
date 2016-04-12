class Suite < ActiveRecord::Base
  belongs_to :project
  has_many :runs, dependent: :destroy
  has_many :tests, through: :runs, dependent: :destroy
  has_many :baselines, dependent: :destroy
  after_initialize :create_slug

  def latest_run
    runs.reversed.first
  end

  def create_slug
    self.slug ||= name.to_s.parameterize
  end

  def to_param
    slug
  end
end
