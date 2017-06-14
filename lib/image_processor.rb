require 'open3'

class ImageProcessor
  ##
  # Crops the area in the image and saves it
  #
  # @param [String] src_image_path path to original image
  # @param [String] crop_area [width]x[height]+[top_left_x]+[top_left_y]
  # @param [String] dest_image_path path to save cropped image
  #
  # @return [Boolean] crop operation result (true/false)
  #
  def self.crop(src_image_path, crop_area, dest_image_path = src_image_path)
    stdout_str, status = Open3.capture2("convert #{src_image_path.shellescape} -crop #{crop_area} #{dest_image_path.shellescape}")
    status.exitstatus == 0
  end
end
