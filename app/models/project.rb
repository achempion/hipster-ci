class Project < ActiveRecord::Base
  has_many :builds, dependent: :destroy

  bitmask :notifications, as: [:github]

  validates :path, presence: true, uniqueness: true

  def last_build
    builds.order(id: :desc).limit(1).first
  end

  def access_token
    super.present? ? super : Rails.configuration.default_project_access_token
  end
end