class Triggers::GithubsController < Triggers::BaseController

  before_action :check_event, :check_project

  def create
    @project.builds.create(sha: github_params[:head_commit][:id], message: github_params[:head_commit][:message])

    head :ok
  end

  private

  def github_params
    params.permit(head_commit: [:id, :message], repository: :full_name)
  end

  def check_event
    head :unprocessable_entity unless ['push'].include? request.headers['X-GitHub-Event']
  end

  def check_project
    @project = Project.find_by(path: github_params[:repository][:full_name])

    head :not_found if @project.nil?
  end

end