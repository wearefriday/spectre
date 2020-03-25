# frozen_string_literal: true

class ProjectsController < ApplicationController
  def index
    @projects = Project.all
  end

  def destroy
    @project = Project.find_by_slug!(params[:slug]).destroy
    redirect_to projects_path
  end
end
