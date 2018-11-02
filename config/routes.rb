Rails.application.routes.draw do
  resources :thermostats, only: [:create]

  get  '/readings/:number', to: 'readings#show'
  post '/readings',         to: 'readings#create'
end
