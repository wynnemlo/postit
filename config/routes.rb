PostitTemplate::Application.routes.draw do
  root to: 'posts#index'

  resources :posts, except: [:destroy] do
    member do
      post :vote
    end
    resources :comments, only: [:create] do
      member do
        post :vote
      end
    end
  end

  resources :categories, only: [:new, :create, :show]

  get '/register', to: 'users#new' #changes the URL for /register
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  
  resources :users, only: [:show, :create, :edit, :update]

end
