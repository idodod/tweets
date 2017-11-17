Rails.application.routes.draw do
  #resources :tweets
  resources :tweets, :only => [:index, :update]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
