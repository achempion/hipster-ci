Rails.application.routes.draw do

  namespace :triggers do
    resource :github, only: :create
  end

  root to: 'projects#index'

  resources :projects, only: [:index, :create, :destroy, :show]
  resources :builds, only: :index do
    member { post 'restart' }
  end
end
