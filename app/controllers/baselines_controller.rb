class ProjectsController < ApplicationController
  def show
    @test = Test.where(key: params[:key], baseline: true).first
    raise ActiveRecord::RecordNotFound if @test.nil?
    send_file @test.screenshot.path, type: 'image/gif', disposition: 'inline'
  end
end
