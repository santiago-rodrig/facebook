Rails.application.routes.draw do
  root 'posts#index'

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :users, only: [:index, :show, :edit, :update] do
    get 'posts', on: :member, to: 'users#user_posts'
    post 'like_post', on: :member, to: 'users#like_post'
    post 'comment_post', on: :member, to: 'users#comment_post'
    delete 'unlike_post', on: :member, to: 'users#unlike_post'
  end

  resources :posts
end
