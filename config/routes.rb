Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :thermostats, only: [:index]
  resources :readings, only: [:index, :show, :create], param: :number
end
