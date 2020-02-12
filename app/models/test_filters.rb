# frozen_string_literal: true

class TestFilters
  def initialize(tests, filter_by_status = false, params)
    @tests = tests
    @params = params
    @filter_by_status = filter_by_status
  end

  def names
    @tests.map(&:name).uniq.sort_by(&:downcase)
  end

  def browsers
    @tests.map(&:browser).uniq.sort_by(&:downcase)
  end

  def sizes
    @tests.map(&:size).uniq.sort_by(&:to_i)
  end

  attr_reader :filter_by_status

  def tests
    @tests = @tests.where(name: @params[:name]) unless @params[:name].blank?
    unless @params[:browser].blank?
      @tests = @tests.where(browser: @params[:browser])
    end
    @tests = @tests.where(size: @params[:size]) unless @params[:size].blank?
    if filter_by_status
      unless @params[:status].blank?
        @tests = @tests.where(pass: (@params[:status] == 'pass'))
      end
    end
    @tests
  end
end
