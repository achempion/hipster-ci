class SchedulerService
  def self.process
    build = Build.scheduled.first

    return false if build.nil?

    BuildRunner.new(build).process
  end

  class BuildRunner
    def initialize build
      @build = build
    end

    def process
      @build.in_progress!

      @result = ''

      okay = prepare_files && prepare_gems && run_specs

      @build.result = @result

      if okay
        @build.success!
      else
        @build.fail!
      end

      write_comment!
    end

    private

    def prepare_files
      `
        rm -rf builds/#{@build.id} &&
        mkdir -p builds/#{@build.id} &&
        cd builds/#{@build.id} &&
        git clone https://#{@build.project.access_token}@github.com/#{@build.project.path} . &&
        git checkout #{@build.sha}
      `

      `rm builds/#{@build.id}/config/database.yml`
      `cp config/build_database.yml builds/#{@build.id}/config/database.yml`

      true
    end

    def prepare_gems
      bundle_status =
        Bundler.with_clean_env do
          system "cd builds/#{@build.id} && bundle > bundle_result 2>&1"
        end

      @result = `cd builds/#{@build.id} && cat bundle_result`

      bundle_status
    end

    def run_specs
      spec_command =
        if File.directory?("builds/#{@build.id}/spec")
          'rspec'
        else
          'rake'
        end

      spec_status =
        Bundler.with_clean_env do
          system "cd builds/#{@build.id} && RAILS_ENV=test bundle exec #{spec_command} > spec_result 2>&1"
        end

      @result = `cd builds/#{@build.id} && cat spec_result`

      spec_status
    end

    def write_comment!
      begin
        GithubService.for_project(@build.project).create_comment(@build.sha, "**#{@build.status.humanize.upcase}**\n```\n#{@build.result}\n```")
      rescue Octokit::Error => e
        @build.result += "\n\nGITHUB EXCEPTION:\n#{e.message}"
        @build.save
      end
    end
  end
end