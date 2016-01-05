class SuitesController < ApplicationController
  def show
    @suite = Suite.find(params[:id])
    @baselines = TestFilters.new(@suite.baselines, params)
  end
end
