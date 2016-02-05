require 'open3'

class ImageGeometry
  attr_reader :width, :height

  def initialize(file_path)
    stdout_str, status = Open3.capture2("identify -verbose #{file_path.shellescape}")
    return unless status.exitstatus == 0
    geometry = /Geometry: (.*)/.match(stdout_str)[1]
    @width = /(\d+)x(\d+)/.match(geometry)[1].to_i
    @height = /(\d+)x(\d+)/.match(geometry)[2].to_i
  end
end
