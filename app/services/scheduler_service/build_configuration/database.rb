module SchedulerService
  class BuildConfiguration
    class Database
      attr_reader :name

      def initialize name
        @name = fit(name)
      end

      def configuration_file
        Rails.root.join("config/build_databases/#{name}.yml")
      end

      private

      def fit database_name
        database_name ||= 'sqlite'

        raise(BuildConfigurationError, "Can't use #{database_name} as custom database") \
          unless %w(sqlite mysql postgres).include?(database_name)

        database_name
      end
    end
  end
end