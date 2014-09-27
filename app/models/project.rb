class Project < ActiveRecord::Base
  has_many :builds, dependent: :destroy
end
