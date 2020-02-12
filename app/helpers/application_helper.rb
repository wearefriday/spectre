# frozen_string_literal: true

module ApplicationHelper
  def thumbnail(thumbnail)
    "<img class='lazy' data-original='#{thumbnail.url}' width='#{thumbnail.width}' height='#{thumbnail.height}' />".html_safe
  end

  def format_date(date)
    "<span title=\"#{date.to_formatted_s(:long_ordinal)}\">#{time_ago_in_words(date)} ago</span>".html_safe
  end

  def authorize!
    return if authenticated?

    reset_session
    oauth_state = SecureRandom.uuid
    session[:state] = oauth_state
    login_uri = 'https://auth.octanner.io/authorize' \
      "?client_id=#{ENV.fetch('OAUTH_CLIENT_ID')}" \
      '&scope=user' \
      "&redirect_uri=#{root_url}auth/callback" \
      "&state=#{oauth_state},#{URI.parse(request.url).path}"
    redirect_to login_uri
  end

  def authenticated?
    if session[:expires].nil? || (session[:expires] < Time.current.to_i)
      reset_session
    end
    session[:access_token] ? true : false
  end
end
