class FriendshipsController < ApplicationController
  def friend_requests
    @user = User.find(params[:user_id])
    @requests = Friendship.requesters(@user)
  end

  def accept_friend_request
    @user = User.find(params[:user_id])
    @friend = User.find(params[:friend_id])
    @friend.friendships.find_by(friend_id: @user.id).toggle!(:confirmed)
    flash[:success] = "you and #{@friend.full_name} are now friends!"

    redirect_to friend_requests_path(user_id: @user.id)
  end

  def reject_friend_request
    @user = User.find(params[:user_id])
    @friend = User.find(params[:friend_id])
    @friend.friendships.find_by(friend_id: @user.id).destroy
    flash[:info] = "you rejected #{@friend.full_name} friendship proposal"

    redirect_to friend_requests_path(user_id: @user.id)
  end

  def ask_friendship
    @user = User.find(params[:user_id])
    @friend = User.find(params[:friend_id])
    @user.friends << @friend
    flash[:info] = "a friendship proposal has been sent to #{@friend.full_name}"

    redirect_to users_path
  end

  def friends_index
    @user = User.find(params[:user_id])
    @title = 'Your friends'
    @partial = 'friend'
    @users = @user.real_friends.paginate(page: params[:page], per_page: 12)

    if params[:page]
      @first_half = @users.offset(12 * (params[:page].to_i - 1)).first(6)
      @second_half = @users.offset(12 * (params[:page].to_i - 1) + 6).first(6)
    else
      @first_half = @users.first(6)
      @second_half = @users.offset(6).first(6)
    end

    render template: 'shared/index'
  end

  def cancel_friendship
    @user = User.find(params[:user_id])
    @friend = User.find(params[:friend_id])

    @friend.friendships.reject do |f|
      f.friend.id == @user.id
    end

    @user.friendships.reject do |f|
      f.friend.id == @friend.id
    end

    @friend.friends.delete(@user)
    @user.friends.delete(@friend)

    redirect_to friends_path(user_id: @user.id)
  end
end
