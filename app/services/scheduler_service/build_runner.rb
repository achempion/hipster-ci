module SchedulerService
  class BuildRunner

    def initialize build
      @build = build
    end

    def process
      @build.in_progress!

      @result = ''

      okay = prepare_files && check_requirements && prepare_libs && prepare_gems && run_specs

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
      Rails.root.join('builds', @build.id.to_s)
    end

    def build_configuration
      @build_configuration ||= BuildConfiguration.new(build_folder)
    end

    def prepare_libs
      return true if `which apt-get`.blank? # libs preparation require apt-get by design

      return true if build_configuration.requirements.empty?

      # todo: sudo is a bad idea
      apt_get_status =
        system "cd #{build_folder} && sudo apt-get --yes --force-yes install #{build_configuration.requirements.join(' ')} > apt_get_result 2>&1"

      @result = File.read build_folder.join('apt_get_result')

      apt_get_status
    end

    def check_requirements
      if build_configuration.database.configuration_file.exist?
        true
      else
        @result = <<-STRING
          Can't configure database because file #{build_configuration.database.configuration_file} does not exist
        STRING

        false
      end
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
      `cp #{build_configuration.database.configuration_file} #{ build_folder.join('config', 'database.yml') }`

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
      success_status_file = build_folder.join('spec_success')

      success_status_file.delete if success_status_file.exist?

      Bundler.with_clean_env do
        with_database = `cd #{build_folder} && rake -T`.include?("rake db")

        exec_command = []
        exec_command << "cd #{build_folder}"
        exec_command << "RAILS_ENV=#{build_configuration.test_environment} rake db:reset > spec_result_raw 2>&1" if with_database

        exec_command <<
          if `echo $OSTYPE`.include? 'darwin' # mac os has a old 2004 version of "script" program
            <<-STRING
              (RAILS_ENV=#{build_configuration.test_environment} script -q /dev/null bundle exec #{build_configuration.spec_command} && touch spec_success; touch spec_done) > spec_result_raw 2>&1
            STRING
          else
            <<-STRING
              script -c "RAILS_ENV=#{build_configuration.test_environment} bundle exec #{build_configuration.spec_command} && touch spec_success; touch spec_done" -q /dev/null > spec_result_raw 2>&1
            STRING
          end

        system exec_command.join(' && ')
      end

      is_spec_done = build_folder.join('spec_done') # workaround for "script" command becomes async without tty
      loop do
        break if is_spec_done.exist?

        sleep 5
      end

      `cd #{build_folder} && cat spec_result_raw | #{Rails.root.join('vendor/shell/convert.sh')} > spec_result 2>&1`

      @result = build_folder.join('spec_result').read

      success_status_file.exist?
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
