Rails.application.routes.draw do
  root 'posts#index'

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions'
  }

  resources :users, only: [:show, :edit, :update]
end
