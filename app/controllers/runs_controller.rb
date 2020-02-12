# frozen_string_literal: true

class RunsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    project = Project.find_by_slug!(params[:project_slug])
    suite = project.suites.find_by_slug!(params[:suite_slug])
    @run = suite.runs.find_by_sequential_id!(params[:sequential_id])
    @test_filters = TestFilters.new(@run.tests, true, params)

    respond_to do |format|
      format.html
      format.json do
        render json: @run.to_json(include: :tests)
      end
    end
  end

  def new
    @run = Run.new
  end

  def create
    project = Project.find_or_create_by(name: params[:project])
    suite = project.suites.find_or_create_by(name: params[:suite])
    @run = suite.runs.create
    render json: @run.to_json
  end
end
