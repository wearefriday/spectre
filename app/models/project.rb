class Project < ActiveRecord::Base
  has_many :suites

  def to_param
    slug
  end
end
