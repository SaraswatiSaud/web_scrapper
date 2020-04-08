# frozen_string_literal: true

Rails.application.routes.draw do
  resources :apps do
    match '/scrape', to: 'apps#scrape', via: :post, on: :collection
  end

  resources :vehicles do
    match '/scrape', to: 'vehicles#scrape', via: :post, on: :collection
  end

  root to: 'apps#index'
end
