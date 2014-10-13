class GithubService
  class Error < StandardError; end

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
    begin
      list = @client.repo(@project_path).rels[:commits].try(:get).try(:data)
    rescue Faraday::ConnectionFailed
      raise Error, 'Github service not available'
    end

    list ? list : (raise Error, 'Commit feed not available')
  end
end