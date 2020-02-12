# frozen_string_literal: true

class SuitesController < ApplicationController
  def show
    @project = Project.find_by_slug!(params[:project_slug])
    @suite = @project.suites.find_by_slug!(params[:slug])

    @baselines = TestFilters.new(@suite.baselines, params)
  end
end
