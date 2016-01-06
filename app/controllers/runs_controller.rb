class RunsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    @suite = Suite.find(params[:suite_id])
    @run = @suite.runs.find_by_sequential_id(params[:id])
    @tests = TestFilters.new(@run.tests, params)
  end

  def new
    @run = Run.new
  end

  def create
    @project = Project.find_by_name(params[:project])
    if @project.nil?
      @project = Project.create(name: params[:project])
    end

    @suite = @project.suites.find_by_name(params[:suite])
    if @suite.nil?
      @suite = @project.suites.create(name: params[:suite])
    end

    @run = @suite.runs.create

    render :json => @run.to_json
  end
end
