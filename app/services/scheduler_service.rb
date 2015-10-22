module SchedulerService

  extend self

  def run!
    return false if alive?

    self.pid =
      Process.fork do
        loop { process; sleep 5 }
      end
  end

  def stop!
    return true unless alive?

    Process.kill 9, pid
  end

  def alive?
    return false unless pid

    begin
      Process.getpgid(pid)

      true
    rescue Errno::ESRCH
      false
    end
  end

  private

  def pid
    pid_form_file =
      begin
        pid_file_storage.read.to_i
      rescue Errno::ENOENT
        0
      end


    if pid_form_file > 0
      pid_form_file
    else
      nil
    end
  end

  def pid= process_id
    pid_file_storage.write process_id
  end

  def pid_file_storage
    file = Rails.root.join('scheduler.pid')

  end

  def process
    build = Build.scheduled.first

    return nil unless build

    begin
      BuildRunner.new(build).process
    rescue => e
      build.result = e.message + "<br><br>" + e.backtrace.join("<br>")
      build.fail!
    end
  end

end