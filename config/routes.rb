Rails.application.routes.draw do
  devise_for :users
  root 'devise/sessions#new'
end
