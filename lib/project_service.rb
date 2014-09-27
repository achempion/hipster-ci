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
    commits.first
  end

  private

  def client
    Octokit::Client.new(access_token: @project_params[:access_token])
  end

  def repository
    client.repo(@project_params[:path])
  end

  def commits
    repository.rels[:commits].get.data
  end
end