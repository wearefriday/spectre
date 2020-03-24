# frozen_string_literal: true

class Api::V1::TestsController < Api::BaseController
  require 'image_processor'

  http_basic_authenticate_with(
    name: 'spectre_api',
    password: ENV['API_PASSWORD'] || SecureRandom.uuid
  )

  def create
    if test_params[:crop_area]
      ImageProcessor.crop(test_params[:screenshot].path, test_params[:crop_area])
    end
    @test = Test.create!(test_params)
    ScreenshotComparison.new(@test, test_params[:screenshot])
    render json: @test.to_json
  end

  private

  def test_params
    params.require(:test).permit(:name, :browser, :size, :screenshot, :run_id, :source_url, :fuzz_level, :highlight_colour, :crop_area)
  end
end
