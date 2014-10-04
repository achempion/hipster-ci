class ProjectService

  # project_params: [:path, :access_token]
  def initialize project_params
    @project_params = project_params
  end

  def create
    project = Project.create(@project_params)

    project.builds.create(sha: last_commit.sha)
  end

  def last_commit
    GithubService.new(@project_params[:project_path], @project_params[:access_token]).last_commit
  end
end