module SchedulerService
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

      notificate!
    end

    private

    def build_folder
      Rails.root.join('builds', @build.id)
    end

    def build_configuration
      @build_configuration ||= BuildConfiguration.new(build_folder)
    end

    def prepare_files
      `
          rm -rf #{build_folder} &&
          mkdir -p #{build_folder} &&
          cd #{build_folder} &&
          git clone https://#{@build.project.access_token}@github.com/#{@build.project.path} . &&
          git checkout #{@build.sha}
      `

      `rm #{ build_folder.join('config', 'database.yml') }`
      `cp config/build_database.yml #{ build_folder.join('config', 'database.yml') }`

      true
    end

    def prepare_gems
      bundle_status =
        Bundler.with_clean_env do
          system "cd #{build_folder} && RAILS_ENV=#{build_configuration.test_environment} bundle > bundle_result 2>&1"
        end

      @result = File.read build_folder.join('bundle_result')

      bundle_status
    end

    def run_specs
      spec_status =
        Bundler.with_clean_env do
          system "cd #{build_folder} && RAILS_ENV=#{build_configuration.test_environment} bundle exec #{build_configuration.spec_command} > spec_result 2>&1"
        end

      @result = File.read build_folder.join('spec_result')

      spec_status
    end

    def notificate!
      if @build.project.notifications?(:github)
        begin
          GithubService.for_project(@build.project).create_comment(@build.sha, "**#{@build.status.humanize.upcase}**\n```\n#{@build.result}\n```")
        rescue Octokit::Error => e
          @build.result += "\n\nGITHUB EXCEPTION:\n#{e.message}"
          @build.save
        end
      end
    end

  end
end