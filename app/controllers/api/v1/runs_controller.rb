# frozen_string_literal: true

class Api::V1::RunsController < Api::BaseController

  http_basic_authenticate_with(
    name: 'spectre_api',
    password: ENV['API_PASSWORD'] || SecureRandom.uuid
  )

  def create
    project = Project.find_or_create_by(name: params[:project])
    suite = project.suites.find_or_create_by(name: params[:suite])
    @run = suite.runs.create
    render json: @run.to_json
  end
end
