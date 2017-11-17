Rails.application.routes.draw do
  #resources :tweets
  resources :tweets, :only => [:index, :update]
  get '/auth/:provider/callback', to: 'sessions#create'
  root to: "tweets#index"
  delete '/logout', to: 'sessions#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
