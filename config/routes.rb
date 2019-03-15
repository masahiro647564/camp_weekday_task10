Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/areas/search' => "areas#form"
  get '/areas/search' => 'areas#search'
  resources :areas
end
