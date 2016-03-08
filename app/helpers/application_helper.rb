module ApplicationHelper

  def thumbnail(thumbnail)
    "<img class='lazy' data-original='#{thumbnail.url}' width='#{thumbnail.width}' height='#{thumbnail.height}' />".html_safe
  end

  def format_date(date)
    "<span title=\"#{date.to_formatted_s(:long_ordinal)}\">#{time_ago_in_words(date)} ago</span>".html_safe
  end
end
