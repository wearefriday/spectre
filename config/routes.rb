# frozen_string_literal: true

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root to: 'projects#index'

  get '/auth/callback', to: 'sessions#create'

  resources :projects, param: :slug, only: [:index] do
    resources :suites, param: :slug, only: [:show] do
      resources :runs, param: :sequential_id, only: [:show]
    end
  end

  resources :runs, only: %i[new]
  resources :tests, only: %i[update new]

  namespace :api do
    namespace :v1 do
      resources :runs, only: %i[create]
      resources :tests, only: %i[create]
    end
  end

  get '/baselines/:key', to: 'baselines#show', as: :baseline
end
