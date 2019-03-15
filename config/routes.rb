Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root  'areas#index'
  post '/areas/search', to: 'areas#form'
  post '/areas', to: 'areas#create'
  get '/areas/search', to: 'areas#search'
end
