module SchedulerService

  def self.process
    build = Build.scheduled.first

    return false if build.nil?

    BuildRunner.new(build).process
  end

end