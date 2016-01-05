Rails.application.routes.draw do

  get '/' => redirect('/projects')

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  resources :projects
  resources :suites
  resources :runs
  resources :tests
end
