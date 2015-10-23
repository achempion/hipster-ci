namespace :scheduler do

  desc 'Build daemon'
  task perform: :environment do

    loop do
      SchedulerService.process

      sleep 5
    end
  end
end