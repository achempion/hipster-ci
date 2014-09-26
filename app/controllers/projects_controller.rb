class ProjectsController < ApplicationController

  def index
    @projects = Project.order(id: :desc)
  end

  def create
    Project.create(project_params)

    redirect_to projects_path
  end

  def destroy
    Project.find_by(params[:id]).destroy

    redirect_to projects_path
  end

  private

  def project_params
    params.require(:project).permit(:path)
  end
end