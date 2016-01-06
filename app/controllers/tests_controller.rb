require 'open3'
require "image_size"
#require 'image_size'
#require 'v8'

class TestsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
    @test = Test.new
  end

  def update
    @test = Test.find(params[:id])

    # TODO: this is implemented poorly. Should it be moved to a modal callback?
    if params[:baseline] == 'true'
      # find the baseline test for this key and unassign it as a baseline
      baseline_test = Test.find_baseline_by_key(@test.key)
      unless baseline_test.nil?
        baseline_test.baseline = false
        baseline_test.save
      end

      # set the new test as the baseline
      @test.baseline = true
      @test.save

      redirect_to project_suite_run_url(@test.run.suite.project, @test.run.suite, @test.run)
    end
  end

  def create
    test_params = params.require(:test).permit(:name, :platform, :browser, :width, :screenshot, :run_id)

    # create test and run validations
    @test = Test.create!(test_params)

    key = @test.create_key
    @test.key = key

    # find an existing baseline screenshot for this test
    baseline_test = Test.find_baseline_by_key(key)

    if baseline_test.nil?
      # if no baseline exists (i.e. this is the first run of this test), mark test as the baseline
      @test.baseline = true
      @test.screenshot_baseline = test_params[:screenshot]
    else
      # otherwise grab the existing baseline image and cache it against this test
      @test.screenshot_baseline = baseline_test.screenshot
    end

    # force save so that dragonfly does it persistence on the baseline image
    @test.save

    # get the width/height of both the baseline and the test image
    baseline_screenshot_details = identify_image_geometry(@test.screenshot_baseline.path)
    test_screenshot_details = identify_image_geometry(@test.screenshot.path)

    # create a canvas using the baseline's dimensions
    canvas = {
      width: baseline_screenshot_details[:width],
      height: baseline_screenshot_details[:height]
    }

    # enlarge the canvas to the wider of the two widths
    if test_screenshot_details[:width] > canvas[:width]
      canvas[:width] = test_screenshot_details[:width]
      @test.dimensions_changed = true
    end

    if test_screenshot_details[:width] < canvas[:width]
      @test.dimensions_changed = true
    end

    # enlarge canvas to the wider of the two heights
    if test_screenshot_details[:height] > canvas[:height]
      canvas[:height] = test_screenshot_details[:height]
      @test.dimensions_changed = true
    end

    if test_screenshot_details[:height] < canvas[:height]
      @test.dimensions_changed = true
    end

    # create temporary files to generate new canvases and diffs
    baseline_screenshot_tmp_path = File.join(Rails.root, 'tmp', "#{@test.id}_baseline.png")
    test_screenshot_tmp_path = File.join(Rails.root, 'tmp', "#{@test.id}_test.png")
    diff_screenshot_tmp_path = File.join(Rails.root, 'tmp', "#{@test.id}_diff.png")

    baseline_resize_command = convert_image_command(@test.screenshot_baseline.path, baseline_screenshot_tmp_path, canvas)
    test_size_command = convert_image_command(@test.screenshot.path, test_screenshot_tmp_path, canvas)
    compare_command = compare_images_command(baseline_screenshot_tmp_path, test_screenshot_tmp_path, diff_screenshot_tmp_path, '20%', 'red')

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

    # assign temporary images to the test to allow dragonfly to process and persist
    @test.screenshot = Pathname.new(test_screenshot_tmp_path)
    @test.screenshot_baseline = Pathname.new(baseline_screenshot_tmp_path)
    @test.screenshot_diff = Pathname.new(diff_screenshot_tmp_path)
    @test.save

    # remove the temporary files
    File.delete(test_screenshot_tmp_path)
    File.delete(baseline_screenshot_tmp_path)
    File.delete(diff_screenshot_tmp_path)

    return render :json => @test.to_json
  end

  private

  # taken from Peter's artefact comparison code
  def identify_image_geometry(file_path)
    stdout_str, status = Open3.capture2("identify -verbose #{file_path.shellescape}")
    if status.exitstatus == 0
      geometry = /Geometry: (.*)/.match(stdout_str)[1]
      {
        geometry: geometry,
        width: /(\d+)x(\d+)/.match(geometry)[1],
        height: /(\d+)x(\d+)/.match(geometry)[2],
      }
    else
      return { file_path: file_path, unsupported: true }
    end
  end

  def convert_image_command(input_file, output_file, canvas)
    "convert #{input_file.shellescape} -background white -extent #{canvas[:width]}x#{canvas[:height]} #{output_file.shellescape}"
  end

  def compare_images_command(baseline_file, compare_file, diff_file, fuzz, highlight_colour)
    "compare -alpha Off -dissimilarity-threshold 1 -fuzz #{fuzz} -metric AE -highlight-color #{highlight_colour} #{baseline_file.shellescape} #{compare_file.shellescape} #{diff_file.shellescape}"
  end

end
