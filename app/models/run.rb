# frozen_string_literal: true

class Run < ActiveRecord::Base
  after_create :purge_old_runs
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
    run[:url] = url
    run
  end

  def passing_tests
    tests.where(pass: true).count
  end

  def failing_tests
    tests.where(pass: false).count
  end

  def url
    Rails.application.routes.url_helpers.project_suite_run_path(suite.project, suite, self)
  end

  private

  def purge_old_runs
    suite.purge_old_runs
  end
end
