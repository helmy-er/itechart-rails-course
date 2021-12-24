# frozen_string_literal: true

Rails.application.routes.draw do
  resources :buffers
  devise_for :users
  root 'pages#home'
  get 'persons/profile'
  resources :people
  resource :expense, only: %i[show destroy edit create update]
  get '/expenses/:people_id', to: 'expenses#index', as: 'expenses'
  get '/expenses/new/:people_id', to: 'expenses#new', as: 'new_expense'
  get '/expenses/create/:people_id', to: 'expenses#create'
  resource :category, only: %i[show destroy edit create update]
  get '/categories/:people_id', to: 'categories#index', as: 'categories'
  get '/categories/new/:people_id', to: 'categories#new', as: 'new_category'
  get '/categories/create/:people_id', to: 'categories#create'
  get '/categories/statistics/categoty_id', to: 'categories#statistics'
  get '/graphik', to: 'categories#grafik'
  get '/notes/:people_id', to: 'expenses#notes', as: 'notes'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
