class Project < ActiveRecord::Base
  has_many :builds, dependent: :destroy
  has_one :last_build, -> { order(id: :desc) }, class_name: 'Build'

  bitmask :notifications, as: [:github]

  validates :path, presence: true, uniqueness: true

  def access_token
    super.present? ? super : Rails.configuration.default_project_access_token
  end
end