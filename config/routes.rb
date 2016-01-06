Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  get '/' => redirect('/projects')

  resources :projects, only: [:index] do
    resources :suites, only: [:show] do
      resources :runs, only: [:show]
    end
  end

  resources :runs, only: [:new, :create]
  resources :tests, only: [:update, :new, :create]
end
