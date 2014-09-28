class BuildsController < ApplicationController

  def index
    @builds = Build.includes(:project).order(updated_at: :desc)
  end

  def restart
    build = Build.find(params[:id])

    build.result = nil
    build.scheduled!

    redirect_to project_path(build.project_id)
  end
end