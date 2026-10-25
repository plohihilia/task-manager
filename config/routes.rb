Rails.application.routes.draw do
  devise_for :users
  
  resources :projects do
    resources :tasks
    resource :kanban, only: [:show] do
      patch :update_status, on: :collection
    end
  end
  
  root "projects#index"
end