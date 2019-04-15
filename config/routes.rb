Rails.application.routes.draw do
  root 'areas#index'
  get '/areas/search', to: "areas#search"
  post '/areas/search', to: "areas#create"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
