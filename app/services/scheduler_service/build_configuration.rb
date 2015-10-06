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
    # darwin14:
    #   spec_command: rspec
    #

    def initialize build_folder
      @build_folder = build_folder

      configuration_file = build_folder.join('config', 'hipster_ci.yml')

      @configuration =
        if configuration_file.exist?
          YAML.load_file(configuration_file).with_indifferent_access
        else
          {}
        end

      @configuration.merge! @configuration[ os_type ] if @configuration.has_key? os_type
    end

    def requirements
      @configuration[:requirements] || []
    end

    def spec_command
      @configuration[:spec_command] || default_spec_command
    end

    def database
      Database.new(@configuration[:database])
    end

    def os_type
      @os_type ||= `echo $OSTYPE`.gsub! "\n", '' # expected: darwin14 (mac os), linux-gnu
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