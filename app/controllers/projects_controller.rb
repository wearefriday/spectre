# frozen_string_literal: true

class ProjectsController < ApplicationController
  def index
    @projects = Project.all
  end

  def destroy
    respond_to do |format|
      @project = Project.find_by_slug!(params[:slug]).destroy
      format.js
      format.html { redirect_to projects_path }
    end
  end
end
