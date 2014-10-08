class ProjectService
  class BuildNotAllowed < StandardError; end

  attr_reader :errors_list

  # project_params: [:path, :access_token]
  def initialize project_params
    @project = Project.new(project_params)
    @errors_list = []
  end

  def save
    return false unless is_valid?

    ActiveRecord::Base.transaction do
      @project.save

      @project.builds.create(sha: last_commit.sha, message: last_commit.commit.message)
    end
  end

  def last_commit
    begin
      GithubService.new(@project.path, @project.access_token).last_commit
    rescue GithubService::Error => e
      raise BuildNotAllowed, "Can't get last commit, the reason is: #{e.message}"
    end
  end

  private

  def is_valid?
    @errors_list += @project.errors.full_messages unless @project.valid?

    begin
      last_commit.sha
    rescue BuildNotAllowed => e
      @errors_list << e.message
    end

    @errors_list.empty?
  end
end