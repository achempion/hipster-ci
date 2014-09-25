Rails.application.routes.draw do

  namespace :triggers do
    resource :github, only: :create
  end

end
