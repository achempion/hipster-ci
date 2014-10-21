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

  def update
    @project = Project.find(params[:id])

    notifications = params[:project].try(:[], :notifications)
    available_notifications = Project.values_for_notifications.map { |name| name.to_s }

    if notifications.is_a?(Array)
      @project.update(
        notifications: notifications.select { |notification| available_notifications.include?(notification) }.compact
      )
    else
      @project.update(notifications: nil)
    end

    redirect_to project_path(@project)
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