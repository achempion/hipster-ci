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

    def initialize build_folder
      @build_folder = build_folder
      @configuration = YAML.load_file build_folder.join('config', 'hipster_ci.yml')
    end

    def requirements
      @configuration[:requirements]
    end

    def spec_command
      @configuration[:spec_command] || default_spec_command
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

  end
end