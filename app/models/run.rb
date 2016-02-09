class Run < ActiveRecord::Base
  belongs_to :suite
  has_many :tests, dependent: :destroy
  acts_as_sequenced scope: :suite_id

  def self.reversed
    order('created_at DESC')
  end

  def to_param
    sequential_id.to_s
  end

  def as_json(options)
    run = super(options)
    run[:url] = self.url
    return run
  end

  def passing_tests
    self.tests.where(pass: true).count
  end

  def failing_tests
    self.tests.where(pass: false).count
  end

  def url
    Rails.application.routes.url_helpers.project_suite_run_path(self.suite.project, self.suite, self)
  end
end
