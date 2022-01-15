Rails.application.routes.draw do

  root 'welcome#index'
  get '/welcome', to: 'welcome#index'
  get '/merchants/:id/dashboard', to: 'merchants#show'

  resources :merchants, except: [:show] do
    resources :items, controller: :merchant_items
    resources :invoices, controller: :merchant_invoices
    resources :invoice_items, controller: :merchant_invoice_items
  end

  resources :admin, only: [:index]

  namespace :admin do
    resources :merchants
    resources :invoices
  end
end
