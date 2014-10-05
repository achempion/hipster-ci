class ProjectsController < ApplicationController

  def index
    @projects = Project.order(id: :desc)
  end

  def create
    project = ProjectService.new(project_params)

    flash[:errors] = project.errors_list unless project.save

    redirect_to projects_path
  end

  def show
    @project = Project.find(params[:id])
    @builds = @project.builds.order(updated_at: :desc)
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