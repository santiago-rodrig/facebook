Rails.application.routes.draw do
  root 'posts#index'

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :users, only: [:index, :show, :edit, :update] do
    get 'posts', on: :member, to: 'users#user_posts'
  end

  # likes
  post 'like_post', to: 'likes#like_post'
  delete 'unlike_post', to: 'likes#unlike_post'

  # comments
  post 'comment_post', to: 'comments#comment_post'

  # friendships
  get 'friend_requests', to: 'friendships#friend_requests'
  get 'friends', to: 'friendships#friends_index'
  post 'accept_friend_request', to: 'friendships#accept_friend_request'
  post 'ask_friendship', to: 'friendships#ask_friendship'
  delete 'reject_friend_request', to: 'friendships#reject_friend_request'
  delete 'cancel_friendship', to: 'friendships#cancel_friendship'

  resources :posts
end
