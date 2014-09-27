class BuildsController < ApplicationController

  def index
    @builds = Build.includes(:project).order(id: :desc)
  end
end