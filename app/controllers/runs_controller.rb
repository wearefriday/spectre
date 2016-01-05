class RunsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    @run = Run.find(params[:id])
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

    render :json => {
      project_id: @project.id,
      project_name: @project.name,
      suite_id: @suite.id,
      suite_name: @suite.name,
      run_id: @run.id,
      run_sequence: @run.sequential_id,
      run_url: @run.url
    }
  end
end
