Rails.application.routes.draw do
  root 'posts#index'

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :users, only: [:index, :show, :edit, :update] do
    get 'posts', on: :member, to: 'users#user_posts'
    get 'friend_requests', on: :member, to: 'users#friend_requests'
    get 'friends', on: :member, to: 'users#friends_index'
    post 'like_post', on: :member, to: 'users#like_post'
    post 'comment_post', on: :member, to: 'users#comment_post'
    post 'accept_friend_request', on: :member, to: 'users#accept_friend_request'
    post 'ask_friendship', on: :member, to: 'users#ask_friendship'
    delete 'unlike_post', on: :member, to: 'users#unlike_post'
    delete 'reject_friend_request', on: :member, to: 'users#reject_friend_request'
    delete 'cancel_friendship', on: :member, to: 'users#cancel_friendship'
  end

  resources :posts
end
