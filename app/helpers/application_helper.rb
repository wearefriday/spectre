module ApplicationHelper
  def thumbnail(thumbnail)
    "<img class='lazy' data-original='#{thumbnail.url}' width='#{thumbnail.width}' height='#{thumbnail.height}' />".html_safe
  end
end
