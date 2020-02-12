# frozen_string_literal: true

class UnauthorizedError < StandardError
end

class SessionsController < ApplicationController
  skip_before_action :authorize!, only: [:create]
  rescue_from UnauthorizedError, with: :unauthorized

  def create
    validate_request

    create_session
    redirect_to URI.parse(URI.encode(request_uri)).path # rubocop:disable Lint/UriEscapeUnescape
  end

  def destroy
    reset_session
    redirect_to 'https://auth.octanner.io/logout'
  end

  private

  def create_session
    reset_session
    session_data = OauthService.fetch_session_data(params.require(:code))
    session.merge!(session_data)
  end

  def unauthorized
    render file: '/public/401.html', status: :unauthorized, layout: false
  end

  def returned_state
    params.require(:state).partition(',').first
  end

  def request_uri
    params.require(:state).partition(',').last
  end

  def validate_request
    raise(UnauthorizedError, params[:error]) if params[:error].present?
    raise(UnauthorizedError, 'State parameter missing') if params[:state].blank?
    unless session[:state] == returned_state
      raise(UnauthorizedError, 'State parameter mismatch')
    end
  end
end
