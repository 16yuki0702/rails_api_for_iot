Rails.application.routes.draw do
  resources :sequences
  resources :readings
  resources :thermostats
end
