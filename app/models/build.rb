class Build < ActiveRecord::Base
  enum status: [:scheduled, :in_progress, :fail, :success]

  belongs_to :project

  def ready_to_restart?
    fail? || success?
  end
end