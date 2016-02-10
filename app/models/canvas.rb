class Canvas
  attr_reader :width, :height, :dimensions_differ

  def initialize(baseline_screenshot_details, test_screenshot_details)
    @width = baseline_screenshot_details.width
    @height = baseline_screenshot_details.height
    @dimensions_differ = false

    adjust_canvas_width(test_screenshot_details)
    adjust_canvas_height(test_screenshot_details)
  end

  def adjust_canvas_width(test_screenshot_details)
    # enlarge the canvas to the wider of the two widths
    if test_screenshot_details.width > @width
      @width = test_screenshot_details.width
      @dimensions_differ = true
    end

    if test_screenshot_details.width < @width
      @dimensions_differ = true
    end
  end

  def adjust_canvas_height(test_screenshot_details)
    # enlarge canvas to the higher of the two heights
    if test_screenshot_details.height > @height
      @height = test_screenshot_details.height
      @dimensions_differ = true
    end

    if test_screenshot_details.height < @height
      @dimensions_differ = true
    end
  end

  def to_h
    {
      width: @width,
      height: @height
    }
  end

end
