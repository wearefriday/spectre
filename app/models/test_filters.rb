class TestFilters
  def initialize(tests, filter_by_status=false, params)
    @tests = tests
    @params = params
    @filter_by_status = filter_by_status
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
    @tests.map{ |test| test.size }.uniq.sort
  end

  def filter_by_status
    @filter_by_status
  end

  def tests
    @tests = @tests.where(name: @params[:name]) unless @params[:name].blank?
    @tests = @tests.where(browser: @params[:browser]) unless @params[:browser].blank?
    @tests = @tests.where(platform: @params[:platform]) unless @params[:platform].blank?
    @tests = @tests.where(size: @params[:size]) unless @params[:size].blank?
    if filter_by_status
      @params[:status] = 'All' if @params[:status].blank?
      @tests = @tests.where(pass: (@params[:status] == 'Pass' ? true : false)) unless @params[:status] == 'All'
    end
    return @tests
  end
end
