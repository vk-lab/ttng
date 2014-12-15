Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    resources :users, except: [:show, :new, :create]
    resources :customers, except: [:show]
    resources :projects, except: [:show]
    resources :days, except: [:show]
  end

  resources :tasks do
    collection do
      get :find
    end

    resources :time_entries, only: :create
  end

  resources :articles, except: [:show] do
    member do
      post :read
      post :unread
    end
  end

  root to: 'welcome#show'
end
