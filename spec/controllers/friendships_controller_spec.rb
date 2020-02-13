require 'rails_helper'

RSpec.describe FriendshipsController, type: :controller do
  before do
    @user = User.create(
      email: 'bob@example.net',
      first_name: 'bob',
      last_name: 'sinclair',
      password: 'secret',
      password_confirmation: 'secret'
    )

    @friend = User.create(
      email: 'lenny@example.com',
      first_name: 'lenny',
      last_name: 'berns',
      password: 'hidden',
      password_confirmation: 'hidden'
    )

    sign_in(@user)
  end

  describe '#friend_requests' do
    before do
      @requests = Friendship.requesters(@controller.current_user)
      get :friend_requests
    end

    it 'GETs' do
      expect(response).to have_http_status(:success)
    end

    it 'sets @requests' do
      expect(assigns(:requests)).to eq(@requests)
    end
  end

  describe '#accept_friend_request' do
    before do
      @friend.friends << @user

      post(
        :accept_friend_request,
        params: {
          friend_id: @friend.id
        }
      )
    end

    it 'redirects' do
      expect(response).to have_http_status(:redirect)
    end

    it 'redirects to #friend_requests' do
      expect(response).to redirect_to(friend_requests_path)
    end

    it 'sets @friend' do
      expect(assigns(:friend)).to eq(@friend)
    end

    it 'sets flash[:success]' do
      expect(@controller.flash[:success]).to(
        eq("you and #{@friend.full_name} are now friends!")
      )
    end

    it 'stablishes the friendship among the users' do
      expect(@user.friends.include?(@friend)).to be_truthy
      expect(@friend.friends.include?(@user)).to be_truthy
      expect(@user.friendships.find_by(friend_id: @friend.id)).to be_confirmed
      expect(@friend.friendships.find_by(friend_id: @user.id)).to be_confirmed
    end
  end

  describe '#reject_friend_request' do
    before do
      @friend.friends << @user

      delete(
        :reject_friend_request,
        params: {
          friend_id: @friend.id
        }
      )
    end

    it 'redirects' do
      expect(response).to have_http_status(:redirect)
    end

    it 'redirects to #friend_requests' do
      expect(response).to redirect_to(friend_requests_path)
    end

    it 'sets @friend' do
      expect(assigns(:friend)).to eq(@friend)
    end

    it 'sets flash[:info]' do
      expect(@controller.flash[:info]).to(
        eq("you rejected #{@friend.full_name} friendship proposal")
      )
    end

    it 'rejects the friendship' do
      expect(@friend.friends.include?(@user)).to be_falsy
    end
  end

  describe '#ask_friendship' do
    before do
      post(
        :ask_friendship,
        params: { friend_id: @friend.id }
      )
    end

    it 'redirects' do
      expect(response).to have_http_status(:redirect)
    end

    it 'redirects to users#index' do
      expect(response).to redirect_to(users_path)
    end

    it 'sets flash[:info]' do
      expect(@controller.flash[:info]).to(
        eq("a friendship proposal has been sent to #{@friend.full_name}")
      )
    end

    it 'starts a friend request' do
      expect(@user.friends.include?(@friend)).to be_truthy
      expect(@user.friendships.find_by(friend_id: @friend.id)).not_to be_confirmed
    end
  end

  describe '#friends_index' do
    before do
      @user.friends << @friend
      @friend.accept_friend(@user)

      @users = @controller.current_user.real_friends.
        paginate(page: @controller.params[:page], per_page: 12)

      @first_half = @users.first(6)
      @second_half = @users.offset(6).first(6)
      @title = 'Your friends'
      @partial = 'friend'
      get :friends_index
    end

    it 'GETs' do
      expect(response).to have_http_status(:success)
    end

    it 'renders shared/index.html.erb' do
      expect(response).to render_template('shared/index')
    end

    it 'sets @users' do
      expect(assigns(:users)).to eq(@users)
    end

    it 'sets @first_half' do
      expect(assigns(:first_half)).to eq(@first_half)
    end

    it 'sets @second_half' do
      expect(assigns(:second_half)).to eq(@second_half)
    end

    it 'sets @title' do
      expect(assigns(:title)).to eq(@title)
    end

    it 'sets @partial' do
      expect(assigns(:partial)).to eq(@partial)
    end
  end

  describe '#cancel_friendship' do
    before do
      @user.friends << @friend
      @friend.accept_friend(@user)

      delete(
        :cancel_friendship,
        params: { friend_id: @friend.id }
      )
    end

    it 'redirects' do
      expect(response).to have_http_status(:redirect)
    end

    it 'redirects to #friends_index' do
      expect(response).to redirect_to(friends_path)
    end

    it 'sets flash[:info]' do
      expect(@controller.flash[:info]).to(
        eq("you and #{@friend.full_name} are no longer friends :(")
      )
    end

    it 'destroys the friendship' do
      expect(@user.friends.include?(@friend)).to be_falsy
      expect(@friend.friends.include?(@user)).to be_falsy
      expect(@user.friendships.find_by(friend_id: @friend.id)).to be_nil
      expect(@friend.friendships.find_by(friend_id: @user.id)).to be_nil
    end
  end
end
