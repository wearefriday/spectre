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

    if params[:baseline] == 'true'
      # find the baseline for this key and remove
      baseline_test = Test.find_baseline_by_key(@test.key)
      unless baseline_test.nil?
        baseline_test.baseline = false
        baseline_test.save
      end

      @test.baseline = true
      @test.save

      redirect_to run_url(@test.run)
    end
  end

  def create
    test_params = params.require(:test).permit(:name, :platform, :browser, :width, :screenshot, :run_id)

    raise "No screenshot" if test_params[:screenshot].nil?

    @test = Test.new(test_params)
    key = @test.create_key

    @test.key = key
    baseline_test = Test.find_baseline_by_key(key)

    if baseline_test.nil?
      @test.baseline = true
      @test.screenshot_baseline = test_params[:screenshot]
    else
      @test.screenshot_baseline = baseline_test.screenshot
    end

    @test.save

    baseline_screenshot_details = identify(@test.screenshot_baseline.path)
    test_screenshot_details = identify(@test.screenshot.path)

    baseline_screenshot_tmp_path = File.join(Rails.root, 'tmp', "#{@test.id}_baseline.png")
    test_screenshot_tmp_path = File.join(Rails.root, 'tmp', "#{@test.id}_test.png")
    diff_screenshot_tmp_path = File.join(Rails.root, 'tmp', "#{@test.id}_diff.png")

    canvas_width = baseline_screenshot_details[:width]
    canvas_height = baseline_screenshot_details[:height]
    canvas_changed = false

    # test is wider, so larger canvas
    if test_screenshot_details[:width] > canvas_width
      canvas_width = test_screenshot_details[:width]
      canvas_changed = true
    end

    #test is smaller width
    if test_screenshot_details[:width] < canvas_width
      canvas_changed = true
    end

    # test is taller
    if test_screenshot_details[:height] > canvas_height
      canvas_width = test_screenshot_details[:height]
      canvas_changed = true
    end

    # test os shallower
    if test_screenshot_details[:height] > canvas_height
      canvas_changed = true
    end

    @test.dimensions_changed = canvas_changed

    baseline_resize_command = "convert #{@test.screenshot_baseline.path.shellescape} -background white -extent #{canvas_width}x#{canvas_height} #{baseline_screenshot_tmp_path.shellescape}"
    test_size_command = "convert #{@test.screenshot.path.shellescape} -background white -extent #{canvas_width}x#{canvas_height} #{test_screenshot_tmp_path.shellescape}"
    compare_command = "compare -alpha Off -dissimilarity-threshold 1 -fuzz 20% -metric AE -highlight-color red #{baseline_screenshot_tmp_path.shellescape} #{test_screenshot_tmp_path.shellescape} #{diff_screenshot_tmp_path.shellescape}"

    px_value = Open3.popen3("#{baseline_resize_command} && #{test_size_command} && #{compare_command}") { |_stdin, _stdout, stderr, _wait_thr| stderr.read }.to_f

    begin
      img_size = ImageSize.path(diff_screenshot_tmp_path).size.inject(:*)
      pixel_count = (px_value / img_size) * 100
      @test.diff = pixel_count.round(2)
      @test.pass = (@test.diff < 0.1)
    rescue
      @test.diff = 0
      @test.pass = false
    end

    @test.screenshot = Pathname.new(test_screenshot_tmp_path)
    @test.screenshot_baseline = Pathname.new(baseline_screenshot_tmp_path)
    @test.screenshot_diff = Pathname.new(diff_screenshot_tmp_path)
    @test.save

    File.delete(test_screenshot_tmp_path)
    File.delete(baseline_screenshot_tmp_path)
    File.delete(diff_screenshot_tmp_path)

    return render :json => {
      test_id: @test.id,
      test_url: @test.url,
      diff: @test.diff,
      pass: @test.pass?
    }
  end

  private
  def identify(file_path)
    stdout_str, status = Open3.capture2("identify -verbose #{file_path.shellescape}")
    if status.exitstatus == 0
      return parse_identify_result(stdout_str)
    else
      return { file_path: file_path, unsupported: true }
    end
  end

  def parse_identify_result(stdout_str)
    geometry = /Geometry: (.*)/.match(stdout_str)[1]
    {
      geometry: geometry,
      height: /(\d+)x(\d+)/.match(geometry)[1],
      width: /(\d+)x(\d+)/.match(geometry)[2],
    }
  end


end
