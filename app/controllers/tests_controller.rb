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

    determine_baseline_test(@test, test_params[:screenshot])

    # force save so that dragonfly does it persistence on the baseline image
    @test.save!

    # get the width/height of both the baseline and the test image
    baseline_screenshot_details = ImageGeometry.new(@test.screenshot_baseline.path)
    test_screenshot_details = ImageGeometry.new(@test.screenshot.path)

    # create a canvas using the baseline's dimensions
    canvas = Canvas.new(baseline_screenshot_details, test_screenshot_details)
    @test.dimensions_changed = canvas.dimensions_differ

    # create temporary files to generate new canvases and diffs
    baseline_screenshot_tmp_path = File.join(Rails.root, 'tmp', "#{@test.id}_baseline.png")
    test_screenshot_tmp_path = File.join(Rails.root, 'tmp', "#{@test.id}_test.png")
    diff_screenshot_tmp_path = File.join(Rails.root, 'tmp', "#{@test.id}_diff.png")

    baseline_resize_command = convert_image_command(@test.screenshot_baseline.path, baseline_screenshot_tmp_path, canvas.to_h)
    test_size_command = convert_image_command(@test.screenshot.path, test_screenshot_tmp_path, canvas.to_h)
    compare_command = compare_images_command(baseline_screenshot_tmp_path, test_screenshot_tmp_path, diff_screenshot_tmp_path, @test.fuzz_level, 'red')

    # run all commands in serial
    compare_result = Open3.popen3("#{baseline_resize_command} && #{test_size_command} && #{compare_command}") { |_stdin, _stdout, stderr, _wait_thr| stderr.read }

    begin
      img_size = ImageSize.path(diff_screenshot_tmp_path).size.inject(:*)
      pixel_count = (compare_result.to_f / img_size) * 100
      @test.diff = pixel_count.round(2)
      # TODO: pull out 0.1 (diff threshhold to config variable)
      @test.pass = (@test.diff < 0.1)
    rescue
      # should probably raise an error here
    end

    if @test.pass == true && @test.baseline == false
      # don't store screenshots for passing tests that aren't baselines
      @test.screenshot = nil
      @test.screenshot_baseline = nil
      @test.screenshot_diff = nil
    else
      # assign temporary images to the test to allow dragonfly to process and persist
      @test.screenshot = Pathname.new(test_screenshot_tmp_path)
      @test.screenshot_baseline = Pathname.new(baseline_screenshot_tmp_path)
      @test.screenshot_diff = Pathname.new(diff_screenshot_tmp_path)
    end

    @test.save

    begin
      @test.create_thumbnails
    rescue
    end

    # remove the temporary files
    File.delete(test_screenshot_tmp_path)
    File.delete(baseline_screenshot_tmp_path)
    File.delete(diff_screenshot_tmp_path)

    return render :json => @test.to_json
  end

  private

  def test_params
    params.require(:test).permit(:name, :platform, :browser, :size, :screenshot, :run_id, :source_url, :fuzz_level)
  end

  def convert_image_command(input_file, output_file, canvas)
    "convert #{input_file.shellescape} -background white -extent #{canvas[:width]}x#{canvas[:height]} #{output_file.shellescape}"
  end

  def compare_images_command(baseline_file, compare_file, diff_file, fuzz, highlight_colour)
    "compare -alpha Off -dissimilarity-threshold 1 -fuzz #{fuzz} -metric AE -highlight-color #{highlight_colour} #{baseline_file.shellescape} #{compare_file.shellescape} #{diff_file.shellescape}"
  end

  def determine_baseline_test(test, screenshot)
    # find an existing baseline screenshot for this test
    baseline_test = Test.find_baseline_by_key(test.key)

    if baseline_test
      # grab the existing baseline image and cache it against this test
      test.screenshot_baseline = baseline_test.screenshot
    else
      # otherwise if no baseline exists (i.e. this is the first run of this test), mark test as the baseline
      test.baseline = true
      test.screenshot_baseline = screenshot
    end

  end

end
