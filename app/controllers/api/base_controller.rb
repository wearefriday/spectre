# frozen_string_literal: true

module Api
  class BaseController < ApplicationController
    protect_from_forgery with: :null_session

    skip_before_action :authorize!

    http_basic_authenticate_with(
      name: 'spectre_api',
      password: ENV['API_PASSWORD'] || SecureRandom.uuid
    )
  end
end
