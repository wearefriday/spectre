# frozen_string_literal: true

require 'net/http'

module OauthService
  def self.fetch_session_data(code)
    access_token_response = access_token_request(code)
    user_response = user_request(access_token_response['access_token'])

    { access_token: access_token_response['access_token'],
      expires: (Time.current + access_token_response['expires_in']).to_i,
      user_id: user_response['sub'],
      name: user_response['nick_name'] }
  end

  def self.access_token_request(code)
    uri = URI('https://auth.octanner.io/access_token')
    http = ::Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = ::Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/x-www-form-urlencoded'
    request.set_form_data(client_id: ENV.fetch('OAUTH_CLIENT_ID'), grant_type: 'authorization_code',
                          client_secret: ENV.fetch('OAUTH_CLIENT_SECRET'), code: code)

    response = http.request(request)
    JSON.parse(response.body)
  end

  def self.user_request(access_token)
    uri = URI('https://auth.octanner.io/user')
    http = ::Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = ::Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{access_token}"

    response = http.request(request)
    JSON.parse(response.body)
  end
end
