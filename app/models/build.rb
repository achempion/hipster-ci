class Build < ActiveRecord::Base
  enum status: [:scheduled, :in_progress, :fail, :success]

  belongs_to :project
end