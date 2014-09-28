class Project < ActiveRecord::Base
  has_many :builds, dependent: :destroy

  def last_build
    builds.order(id: :desc).limit(1).first
  end
end
