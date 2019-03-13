Rails.application.routes.draw do
  resources :areas do
    collection do
      get 'search'
      post 'search'
    end
  end
  root 'areas#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
