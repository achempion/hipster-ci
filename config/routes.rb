Rails.application.routes.draw do

  namespace :triggers do
    resource :github, only: :create
  end

  root to: 'projects#index'

  resources :projects, only: [:index, :create, :destroy, :show, :update]
  resources :builds, only: [:index, :show] do
    member { post 'restart' }
  end

  resource :builds_feedback, only: :show
  resource :scheduler, only: [:create, :destroy]
end
