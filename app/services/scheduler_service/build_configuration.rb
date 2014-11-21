module SchedulerService
  class BuildConfiguration

    #
    # Configuration example
    #
    # /config/hipster_ci.yml
    # ----------------------
    # requirements:
    #   - xfvb
    #   - curl
    #   - mysql-server
    #
    # spec_command: xvfb-run rspec
    #
    # database: mysql
    #

    def initialize build_folder
      @build_folder = build_folder

      configuration_file = build_folder.join('config', 'hipster_ci.yml')
      @configuration =
        if configuration_file.exist?
          YAML.load_file(build_folder.join('config', 'hipster_ci.yml')).with_indifferent_access
        else
          {}
        end
    end

    def requirements
      @configuration[:requirements] || []
    end

    def spec_command
      @configuration[:spec_command] || default_spec_command
    end

    def database
      adapter = @configuration[:database] || 'sqlite'

      if %w(sqlite mysql).include?(adapter)
        adapter
      else
        raise BuildConfigurationError, "Can't use #{adapter} as custom database"
      end
    end

    def test_environment
      'test'
    end

    private

    def default_spec_command
      if File.directory?(@build_folder.join('spec'))
        'rspec'
      else
        'rake'
      end
    end

    class BuildConfigurationError < StandardError; end

  end
end