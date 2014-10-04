class GithubService
  def initialize project_path, access_token
    @project_path = project_path
    @client = Octokit::Client.new(access_token: access_token)
  end

  def last_commit
    commits.first
  end

  def create_comment sha, message
    @client.create_commit_comment(@project_path, sha, message)
  end

  def self.for_project project
    self.new(project.path, project.access_token)
  end

  private

  def commits
    @client.repo(@project_path).rels[:commits].get.data
  end
end