Rails.application.routes.draw do
  root to: 'enrico_items#index'
  resources :enrico_items
end
