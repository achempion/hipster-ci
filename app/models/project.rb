class Project < ActiveRecord::Base
  has_many :builds, dependent: :destroy

  validates_presence_of :path

  def last_build
    builds.order(id: :desc).limit(1).first
  end

  def access_token
    super.present? ? super : Rails.configuration.default_project_access_token
  end
end