class Run < ActiveRecord::Base
  belongs_to :suite
  has_many :tests
  acts_as_sequenced scope: :suite_id

  def self.reversed
    order('created_at DESC')
  end

  def to_param
    sequential_id.to_s
  end

  def passing_tests
    self.tests.where(pass: true).count
  end

  def failing_tests
    self.tests.where(pass: false).count
  end

  # TODO: how to access routes from within a model?
  def url
    "/runs/#{id}"
  end
end
