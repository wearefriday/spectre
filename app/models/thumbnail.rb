require 'image_size'

class Thumbnail
  THUMBNAIL_ROOT_PATH = "system/dragonfly/#{Rails.env}/thumbnails"

  def initialize(asset)
    @asset = asset
  end

  def create_thumbnail
    @asset.thumb('300x')
  end

  def thumbnail_filename
    Digest::SHA1.hexdigest(@asset.url)
  end

  def thumbnail_file_path
    File.join(Rails.root.join('public', THUMBNAIL_ROOT_PATH), thumbnail_filename)
  end

  def width
    ImageSize.path(thumbnail_file_path).size[0]
  end

  def height
    ImageSize.path(thumbnail_file_path).size[1]
  end

  def url
    file = thumbnail_file_path
    unless File.exists?(file)
      begin
        create_thumbnail.to_file(file)
      rescue Exception => e

      end
    end
    "/#{THUMBNAIL_ROOT_PATH}/#{thumbnail_filename}"
  end
end
