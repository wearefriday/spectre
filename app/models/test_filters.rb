class TestFilters
  def initialize(tests, params)
    @tests = tests
    @params = params
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

  def tests
    @tests = @tests.where(name: @params[:name]) unless @params[:name].blank?
    @tests = @tests.where(browser: @params[:browser]) unless @params[:browser].blank?
    @tests = @tests.where(platform: @params[:platform]) unless @params[:platform].blank?
    @tests = @tests.where(width: @params[:size]) unless @params[:size].blank?
    @tests = @tests.where(pass: (@params[:result] == 'Pass' ? true : false)) unless @params[:result].blank?
    return @tests
  end
end
