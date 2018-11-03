Rails.application.routes.draw do
  resources :thermostats, only: [:create]
  resources :stats, only: [:index]

  get  '/readings/:number', to: 'readings#show'
  post '/readings',         to: 'readings#create'
end
