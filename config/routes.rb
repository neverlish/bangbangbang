Rails.application.routes.draw do
  get 'mapia/create'

  get 'mapia_info/create'


  # devise_for :users
	devise_for :users, :controllers => { registrations: 'registrations' }

  resources :messages, only: [:index]
  resources :sessions, only: [:new, :create]
  root 'sessions#new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount ActionCable.server => '/cable'
end
