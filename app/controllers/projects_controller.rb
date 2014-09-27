class ProjectsController < ApplicationController

  def index
    @projects = Project.order(id: :desc)
  end

  def create
    ProjectService.new(project_params).create

    redirect_to projects_path
  end

  def show
    @project = Project.find(params[:id])
  end

  def destroy
    Project.find(params[:id]).destroy

    redirect_to projects_path
  end

  private

  def project_params
    params.require(:project).permit(:path, :access_token)
  end
end