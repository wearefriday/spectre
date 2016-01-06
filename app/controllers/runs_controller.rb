class RunsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    @project = Project.find_by_slug(params[:project_slug])
    @suite = @project.suites.find_by_slug(params[:suite_slug])
    @run = @suite.runs.find_by_sequential_id(params[:sequential_id])
    @tests = TestFilters.new(@run.tests, params)
  end

  def new
    @run = Run.new
  end

  def create
    @project = Project.find_by_name(params[:project])
    if @project.nil?
      @project = Project.create(name: params[:project], slug: params[:project].parameterize)
    end

    @suite = @project.suites.find_by_name(params[:suite])
    if @suite.nil?
      @suite = @project.suites.create(name: params[:suite], slug: params[:suite].parameterize)
    end

    @run = @suite.runs.create

    render :json => @run.to_json
  end
end
