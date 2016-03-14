require 'image_size'
require 'image_geometry'

class TestsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
    @test = Test.new
  end

  def update
    @test = Test.find(params[:id])

    # TODO: this is implemented poorly. Should it be moved to a modal callback?
    if params[:test][:baseline] == 'true'
      # find the baseline test for this key and unassign it as a baseline
      baseline_test = Test.find_baseline_by_key(@test.key)
      unless baseline_test.nil?
        baseline_test.baseline = false
        baseline_test.save
      end

      # this test is now a pass!
      @test.pass = true

      # set the new test as the baseline
      @test.baseline = true
      @test.save

      redirect_to project_suite_run_url(@test.run.suite.project, @test.run.suite, @test.run)
    end
  end

  def create
    # create test and run validations
    @test = Test.create!(test_params)
    ScreenshotComparison.new(@test, test_params[:screenshot])
    # TODO: why are we rescuing this? Can we fix the problem?
    begin
      @test.create_thumbnails
    rescue
    end

    render json: @test.to_json
  end

  private

  def test_params
    params.require(:test).permit(:name, :platform, :browser, :size, :screenshot, :run_id, :source_url, :fuzz_level)
  end
end
