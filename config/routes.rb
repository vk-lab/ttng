Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    resources :users, except: [:show, :new, :create]
    resources :customers, except: [:show]
    resources :projects do
      resources :project_infos, except: :index
      member do
        get :to_google_drive
      end
    end
    resources :days, except: [:show]
  end
  controller :sessions do
    get '/auth/:provider/callback' => 'sessions#create'
  end
  resources :sessions, only: :index

  
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
