class SchedulersController < ApplicationController

  def create
    SchedulerService.run!

    head :ok
  end

  def destroy
    SchedulerService.stop!

    head :ok
  end
end