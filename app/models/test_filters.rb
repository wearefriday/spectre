class TestFilters
  def initialize(tests, filter_by_result=false, params)
    @tests = tests
    @params = params
    @filter_by_result = filter_by_result
  end

  def names
    @tests.map{ |test| test.name }.uniq.sort
  end

  def browsers
    @tests.map{ |test| test.browser }.uniq.sort
  end

  def platforms
    @tests.map{ |test| test.platform }.uniq.sort
  end

  def sizes
    @tests.map{ |test| test.width }.uniq.sort
  end

  def filter_by_result
    @filter_by_result
  end

  def tests
    @tests = @tests.where(name: @params[:name]) unless @params[:name].blank?
    @tests = @tests.where(browser: @params[:browser]) unless @params[:browser].blank?
    @tests = @tests.where(platform: @params[:platform]) unless @params[:platform].blank?
    @tests = @tests.where(width: @params[:size]) unless @params[:size].blank?
    if filter_by_result
      @tests = @tests.where(pass: (@params[:result] == 'Passed' ? true : false))
    end
    return @tests
  end
end
