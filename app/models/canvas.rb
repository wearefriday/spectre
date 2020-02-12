# frozen_string_literal: true

class Canvas
  attr_reader :width, :height, :dimensions_differ

  def initialize(image_geometry, comparison_image_geometry)
    @width = image_geometry.width
    @height = image_geometry.height
    @dimensions_differ = false

    adjust_canvas_width(comparison_image_geometry)
    adjust_canvas_height(comparison_image_geometry)
  end

  def adjust_canvas_width(comparison_image_geometry)
    # enlarge the canvas to the wider of the two widths
    if comparison_image_geometry.width > @width
      @width = comparison_image_geometry.width
      @dimensions_differ = true
    end

    @dimensions_differ = true if comparison_image_geometry.width < @width
  end

  def adjust_canvas_height(comparison_image_geometry)
    # enlarge canvas to the higher of the two heights
    if comparison_image_geometry.height > @height
      @height = comparison_image_geometry.height
      @dimensions_differ = true
    end

    @dimensions_differ = true if comparison_image_geometry.height < @height
  end

  def to_h
    {
      width: @width,
      height: @height
    }
  end
end
