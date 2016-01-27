class Project < ActiveRecord::Base
  has_many :suites
  after_initialize :create_slug

  def create_slug
    self.slug ||= name.to_s.parameterize
  end

  def to_param
    slug
  end
end
